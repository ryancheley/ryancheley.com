Title: Using OpenTofu to manage your Infrastructure as Code
Date: 2026-11-03
Author: ryan
Tags: iac, opentofu, terraform, infrastructure-as-code
Slug: using-opentofu-to-manage-your-infrastructure-as-code
Series: learnings-on-leave
Status: draft

In the [Django Commons](https://github.com/django-commons) organization we use [OpenTofu](https://opentofu.org/) to manage our infrastructure as code (IaC).

While we have done this since the very beginning (though we initially started with Terraform instead of OpenTofu), I was always a bit unsure as to what is actually happening. I decided the best way to understand it was to just dive in, head first, and use it for some of my own personal infrastructure.

> OpenTofu is an open source forked alternative to Terraform version 1.5.6. Why an open source alternative? HashiCorp changed the license from Mozilla Public License (MPL) 2.0 to the Business Source License (BSL) on August 10, 2023. For more, read their [Manifesto](https://opentofu.org/manifesto/).

## Key Concepts

Before getting into my own setup, there are a few key concepts worth going over:

- [Provider](#provider)
- [Resource](#resource)
- [Module](#module)
- [Root Module](#root-module)
- [Variable](#variable)
- [Output](#output)
- [State](#state)
- [Workspaces](#workspaces)

### Provider

OpenTofu has a LOT of [providers](https://search.opentofu.org/providers). Providers are plugins that let OpenTofu create, read, update, and delete resources on a given platform (AWS, GitHub, Hetzner, etc). You write your configuration in a consistent way, and the provider takes care of talking to that platform's API for you.

### Resource

Resources are the actual things you're managing ... servers, DNS records, firewalls, etc. Per the [docs](https://opentofu.org/docs/language/resources/behavior/):

> In summary, applying an OpenTofu configuration will:
>
> - _Create_ resources that exist in the configuration but are not associated with a real infrastructure object in the state.
> - _Destroy_ resources that exist in the state but no longer exist in the configuration.
> - _Forget_ resources that exist in the state but no longer in the configuration and are referenced in a `removed` block within the configuration.
> - _Update in-place_ resources whose arguments have changed.
> - _Destroy and re-create_ resources whose arguments have changed but which cannot be updated in-place due to remote API limitations.

Each resource type is implemented by a [provider](https://opentofu.org/docs/language/providers/requirements/). There are also several meta-arguments you can set:

- `create_before_destroy`: does what it says, but there are some limitations depending on the API you're interacting with
- `enabled`: determines if the resource is managed by OpenTofu at all (similar to the idea of managed tables in Django)
- `prevent_destroy`: stops OpenTofu from destroying the resource. You'll see me use this below when I set up Hetzner
- `destroy`: when set to `false` it acts kind of like a soft delete flag
- `ignore_changes`: useful for things that might change outside of OpenTofu. The example in the docs is tags that get added to a resource at the source
- `lifecycle.precondition` and `lifecycle.postcondition`: these "can help capture assumptions, helping future maintainers understand the configuration design and intent" per the [docs](https://opentofu.org/docs/language/resources/syntax/#custom-condition-checks)

A few other things that stood out:

- You can set [operation timeouts](https://opentofu.org/docs/language/resources/syntax/#operation-timeouts)
- You *might* get [deprecation warnings](https://opentofu.org/docs/language/resources/syntax/#deprecation-of-blocks-and-attributes)
- [`terraform_data`](https://opentofu.org/docs/language/resources/tf-data/) is confusing. I asked Claude to explain it, and what made it click was this: `replace_triggered_by` only works with resources, so you can't point it at a plain variable or local. `terraform_data` wraps a plain value in a resource, so changing that value can trigger a replacement. It's also handy as a do-nothing container for provisioners when there's no other resource that makes sense to hang them on.

One last thing on resources. [File Provisioners](https://opentofu.org/docs/language/resources/provisioners/syntax/#provisioners-are-a-last-resort) should be used as a last resort. The docs suggest using `cloud-init` instead.

### Module

Modules are how you group resources together. A couple of things I noticed:

- Only provider *configurations* are inherited by child modules, not provider source or version requirements. Each module has to [declare its own provider requirements](https://opentofu.org/docs/language/providers/requirements/). This is especially important for non-HashiCorp providers.
- When you've outgrown your initial configuration, check out [Refactoring](https://opentofu.org/docs/language/modules/develop/refactoring/) in the docs

### Root Module

Every OpenTofu configuration has at least one module, known as its [root module](https://opentofu.org/docs/language/modules/#the-root-module). This is just the resources defined in the `.tf` or `.tofu` files in the directory you're running `tofu` from.

### Variable

Input variables are like function arguments. Some things I learned about them:

- You can [add a description](https://opentofu.org/docs/language/values/variables/#input-variable-documentation) which acts like a doc string for the variable
- Setting `sensitive = true` will keep the value out of the `plan` and `apply` output
- Be careful though ... errors can [leak](https://opentofu.org/docs/language/values/variables/#cases-where-opentofu-may-disclose-a-sensitive-variable) these sensitive values
- Ephemeral variables are available by setting `ephemeral = true`

I wasn't sure when I'd use an ephemeral variable instead of a sensitive one, so I asked Claude. Ephemeral variables are for secrets that OpenTofu needs while it runs but should never write down. Their values aren't stored in state at all, and only the variable *names* are saved in the plan. A sensitive value, on the other hand, is still stored in state and in saved plan files. Only the display is masked. I had assumed they did the same thing!

You can set variables individually on the command line, or put them in a `*.tfvars` file to read from. This feels a lot like `docker` with flags vs. docker compose with a `docker-compose.yml` file. OpenTofu will also automatically load variable definition files if they're present:

- Files named exactly `terraform.tfvars` or `terraform.tfvars.json`
- Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`

If the same variable is assigned more than once, OpenTofu uses the _last_ value it finds. See the [docs](https://opentofu.org/docs/language/values/variables/#variable-definition-precedence) for the full precedence order.

### Output

Per the [docs](https://opentofu.org/docs/language/values/outputs/):

> Output values make information about your infrastructure available on the command line, and can expose information for other OpenTofu configurations to use. Output values are similar to return values in programming languages.

You can use `precondition` and `postcondition` here too, and there's a `depends_on` key that works a lot like it does in docker compose.

### State

The primary purpose of state is to store the bindings between objects in a remote system and the resources declared in your configuration. A couple of things here:

- `import` is how you bring in [existing resources](https://opentofu.org/docs/language/import/). This is what I ended up using for my own infrastructure
- [Remote State](https://opentofu.org/docs/language/state/remote/) is what lets you store a single state file that everyone on a team has access to ... similar to what Daniel set up for us at Django Commons

The [`terraform_remote_state` docs](https://opentofu.org/docs/language/state/remote-state-data/#example-usage-remote-backend) look scary at first. I initially read them as a lot of "You can do this, but you shouldn't." The concern is that `terraform_remote_state` exposes the entire state file, which can include secrets that another team maybe shouldn't have access to. This is one of those questions of: will my current setup ALWAYS be just me and NEVER change? If the answer is yes, then this is a perfectly acceptable way to proceed ... but remember, ALWAYS and NEVER are very long times.

### Workspaces

A [video I watched](https://youtu.be/BZ2TLtf3yFg?si=un-QoHhEaZyiHYwq) seemed to imply that workspaces could be used for different environments. Based on the [docs](https://opentofu.org/docs/language/state/workspaces/) that doesn't seem to be true.

I asked Claude and it seems I'm reading it correctly. For separate environments you really want different directories like `envs/prod` and `envs/staging`. The best use case for workspaces is temporary clones where you want to test something out before applying it to prod. Something like:

```bash
tofu workspace new scratch
tofu apply # throwaway copy, e.g. a test Hetzner server
tofu destroy
tofu workspace select default
```

---

## Using OpenTofu to manage my own infrastructure

To help solidify what I'd learned, I decided to use OpenTofu to manage my own infrastructure. For that I used the following providers:

- AWS
- Coolify
- DigitalOcean
- GitHub
- Hetzner
- Tailscale

In my case I'm importing what I already have, not adding new things (yet!).

Here's a quick walkthrough of setting up Hetzner with OpenTofu:

1. Created an `infra` directory, and then a `hetzner` directory inside of it
2. Created `main.tf` and added the Hetzner provider
3. Ran `tofu init`
4. Created `imports.tf` to catalog all of the infrastructure I wanted to import
5. Ran `tofu plan -generate-config-out=generated.tf`, which created `generated.tf`. I did have to set the `HCLOUD_TOKEN` environment variable first with `set -x HCLOUD_TOKEN (op read "op://token-location")`[ref]I did get a scary warning: "Note: You didn't use the -out option to save this plan, so OpenTofu can't guarantee to take exactly these actions if you run "tofu apply" now." It seems to be directed more at teams, where something may change between the `plan` and the `apply`. Since it's just me, there's little risk here.[/ref]
6. Updated each server with a `lifecycle` block to prevent any accidental destruction:

    ```hcl
    lifecycle {
      ignore_changes  = [image, user_data, ssh_keys]
      prevent_destroy = true
    }
    ```

7. Encrypted the state file (this was a [pita](https://www.merriam-webster.com/slang/pita)). State holds everything OpenTofu knows about your resources, and depending on the provider that can include secrets, so I wanted it encrypted. OpenTofu has [native state encryption](https://opentofu.org/docs/language/state/encryption/) built in, which is one of the things it has that Terraform doesn't. I added an `encryption` block to the `terraform` block:

    ```hcl
    terraform {
      encryption {
        key_provider "pbkdf2" "main" {
          passphrase = var.state_passphrase # at least 16 characters
        }
        method "aes_gcm" "main" {
          keys = key_provider.pbkdf2.main
        }
        state {
          method   = method.aes_gcm.main
          enforced = true
        }
        plan {
          method   = method.aes_gcm.main
          enforced = true
        }
      }
    }
    ```

    along with a `state_passphrase` variable (marked `sensitive`). The passphrase lives in 1Password, and I pass it in as `TF_VAR_state_passphrase` with `op run`. `enforced = true` means OpenTofu will refuse to write state or plans unencrypted.

    It was a pita because I had already imported everything, so my state file was sitting there unencrypted, and OpenTofu won't read it once you've told it everything should be encrypted. To migrate it I had to:

    1. Back up `terraform.tfstate` (just in case!)
    2. Remove `enforced = true` for now. While it's set you get "Unable to use unencrypted method since the enforced flag is set."
    3. Add a temporary `method "unencrypted" "migrate" {}` and a `fallback { method = method.unencrypted.migrate }` inside both `state` and `plan`. This lets OpenTofu read the plain state one last time
    4. Run `tofu apply -refresh-only`, then check with `grep -c encrypted_data terraform.tfstate`. If it prints 1, the state is encrypted
    5. Remove the `unencrypted` method and both `fallback` blocks, put `enforced = true` back, and make sure `tofu plan` reports "No changes"

    A few gotchas:

    - Plain `tofu init` stops working. The encryption block needs the passphrase, so even `init` has to run through `op run`
    - Don't lose the passphrase! Without it, the state is unreadable. Same goes for removing the `encryption` block later ... treat it as permanent
    - Keep the passphrase in its own 1Password item, not as a field on a provider's API token item. Otherwise rotating that token could change your state key

    If I were doing this again, I'd turn encryption on *before* the first import and skip the whole migration dance.

Some caveats:

1. For Hetzner, make sure every server has `prevent_destroy = true` (see step 6 above). You do NOT want a typo to delete a server
2. For Tailscale, import your ACL policy and use `tailscale_device` data sources for your machines (all ten in my case). Be careful though ... a bad policy can lock you out of your machines
3. Don't let Coolify create Hetzner servers, as they will collide with the `hcloud` provider

As things evolved, I refactored from having just `main.tf` and `generated.tf` to having the following `*.tf` files:

- `dns.tf`
- `firewalls.tf`
- `primary_ips.tf`
- `providers.tf`
- `rdns.tf`
- `servers.tf`
- `ssh_keys.tf`
- `variables.tf`
- `versions.tf`
- `zones.tf`

Each one is named for the resources it's managing. This led me to wonder:

> When I run `tofu plan` or `tofu apply`, what order do the `*.tf` files get processed in? Does it matter what I name them?

I did some research, and also asked Claude. Names don't affect the order. OpenTofu loads every `.tf` file in the directory, merges them into one configuration, and then works out the order from the references between blocks.

A little more detail on how that works:

- When you run `tofu plan` or `tofu apply`, it reads every `.tf` and `.tf.json` file in the current directory. It does NOT read subdirectories
- It reads the files alphabetically, but that has no effect on the result. All of the blocks are merged as if they were in one file
- It then builds a dependency graph from the references between blocks. If `hcloud_server.webp1` uses `hcloud_firewall.firewall.id`, the firewall is handled first, no matter which file each one is defined in. Resources that don't depend on each other run in parallel, 10 at a time by default
- If the graph misses a dependency, you add `depends_on`. My Tailscale config does this so the ACL is applied before the auth key. Renaming or reordering files will never fix ordering

This is also why, when I moved my state bucket from `main.tf` into `s3.tf`, the plan showed no changes. A resource's address (`aws_s3_bucket.resource_name`) is the same no matter which file it's in.

That said, there are a few cases where file names DO matter:

- **Override files**: files named `override.tf` or ending in `_override.tf` are loaded last. Their blocks are merged into blocks with the same name instead of being treated as duplicates. Avoid these unless you really mean to use them
- **`.tofu` files**: OpenTofu also reads `.tofu` and `.tofu.json` files. If `foo.tofu` and `foo.tf` both exist, it uses `foo.tofu` and ignores `foo.tf`
- **Test files**: `.tftest.hcl` and `.tofutest.hcl` files are only used by `tofu test`
- **Ignored files**: editor temp files (names ending in `~` or wrapped in `#...#`) are skipped, as is any other extension. My Tailscale `policy.hujson` only gets read because I load it with `file()`
- **Duplicates**: a block defined twice is an error, no matter which files the two copies are in
