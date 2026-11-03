Title: Using OpenTofu to manage your Infrastructure as Code
Date: 2026-11-03
Author: ryan
Tags: iac, opentofu, terraform, infrastructure-as-code
Slug: using-opentofu-to-manage-your-infrastructure-as-code
Series: learnings-on-leave
Status: draft

In the [Django Commons](https://github.com/django-commons) organization we use [OpenTofu](https://opentofu.org/) to manage the infrastructure using Infrastructure as Code (IaC).

While we have done this since the very beginning (though we initially started with Terraform instead of OpenTofu), I was always a bit unsure as to what is actually happening. I decided that in order to better understand OpenTofu I'd need to just dive in, head first, and use it for some of my own personal infrastructure to get a better sense of it.

> OpenTofu is an open source forked alternative to Terraform version 1.5.6. Why an open source alternative? HashiCorp changed the license from Mozilla Public License (MPL) 2.0 to the Business Source License (BSL) on August 10, 2023. For more, read their [Manifesto](https://opentofu.org/manifesto/).

## Key Concepts

There are a few key concepts to go over:

- [Provider](#provider)
- [Resource](#resource)
- [Module](#module)
- [Root Module](#root-module)
- [Variable](#variable)
- [Output](#output)
- [State](#state)
- [Workspaces](#workspaces)

### Provider

OpenTofu has many [providers](https://search.opentofu.org/providers). Providers are plugins to OpenTofu. They allow you to create, read, update, and delete resources from those providers using a consistent 'front end' API to the provider's API. This is all based on your OpenTofu configuration.

### Resource

Per the [Docs](https://opentofu.org/docs/language/resources/behavior/)

> In summary, applying an OpenTofu configuration will:
>
> - _Create_ resources that exist in the configuration but are not associated with a real infrastructure object in the state.
> - _Destroy_ resources that exist in the state but no longer exist in the configuration.
> - _Forget_ resources that exist in the state but no longer in the configuration and are referenced in a `removed` block within the configuration.
> - _Update in-place_ resources whose arguments have changed.
> - _Destroy and re-create_ resources whose arguments have changed but which cannot be updated in-place due to remote API limitations.

Each resource type is implemented by a [provider](https://opentofu.org/docs/language/providers/requirements/). There are several Meta Attributes worth looking at

- `create_before_destroy`: this can be used, but there are some limitations based on the API that you're interacting with
- `enabled`: which determines if the resource is managed by OpenTofu (similar to the idea of managed tables in Django)
- `prevent_destroy`: prevents destruction by OpenTofu (something we see above for the Hetzner migration to OpenTofu)
- `destroy`: is like a soft delete kind of flag when set to `false`
- `ignore_changes` useful on items associated with resources that might change outside of OpenTofu. The example given in the docs are things like tags on resources added at the source
- `lifecycle.precondition` and `lifecycle.postcondition` "can help capture assumptions, helping future maintainers understand the configuration design and intent" per the [docs](https://opentofu.org/docs/language/resources/syntax/#custom-condition-checks)
- You can apply [operation timeouts](https://opentofu.org/docs/language/resources/syntax/#operation-timeouts)
- you *might* get [deprecation warnings](https://opentofu.org/docs/language/resources/syntax/#deprecation-of-blocks-and-attributes)
- `terraform_data` [link](https://opentofu.org/docs/language/resources/tf-data/)  is confusing. I asked Claude to explain it to me and this is what it came up with: One idea explains the whole page: OpenTofu only takes actions, like running provisioners or forcing replacements, in response to changes in resources. Plain values like variables and locals can't trigger anything. `terraform_data` turns a plain value into a resource, so its changes can trigger things.

One thing worth noting. [File Provisioners](https://opentofu.org/docs/language/resources/provisioners/syntax/#provisioners-are-a-last-resort) should be used as a last resort; the docs indicate you should prefer `cloud-init` over File Provisioners


### Module

- Only provider configurations are inherited by child modules, not provider source or version requirements. Each module must [declare its own provider requirements](https://opentofu.org/docs/language/providers/requirements/). This is especially important for non-HashiCorp providers.
- When you've outgrown your initial configuration, refer to [Refactoring](https://opentofu.org/docs/language/modules/develop/refactoring/) in the docs

### Root Module

- Every OpenTofu configuration has at least one module, known as its [root module]((https://opentofu.org/docs/language/modules/#the-root-module)), which consists of the resources defined in the `.tf` or `.tofu` files in the main working directory.

### Variable

- Input variables are like function arguments.
- you can [add a description](https://opentofu.org/docs/language/values/variables/#input-variable-documentation) to act as a doc string for a variable
- setting `sensitive` to `true` will prevent the value from being in `plan` or `apply` output
- be careful though, errors can [leak](https://opentofu.org/docs/language/values/variables/#cases-where-opentofu-may-disclose-a-sensitive-variable) these sensitive values
- Ephemeral Variables are available by setting `ephemeral = true`
- Per Claude: You'd use an ephemeral variable for secrets that OpenTofu needs while it runs but should never write down. OpenTofu will not store ephemeral variable values in the state at all, and only the variable names are saved in the plan. That differs from `sensitive = true`, which people often assume does the same thing. A sensitive value is still stored in state and saved plan files, and only the display is masked. Ephemeral means the value genuinely never persists.
- you can set variables individually in the command line, or create a `*.tfvars` file to read from. This seems similar to `docker` with flags and docker compose using a `docker-compose.yml` file
- OpenTofu also automatically loads a number of variable definitions files if they are present:
	- Files named exactly `terraform.tfvars` or `terraform.tfvars.json`.
	- Any files with names ending in `.auto.tfvars` or `.auto.tfvars.json`.
- If the same variable is assigned multiple values, OpenTofu uses the _last_ value it finds, overriding any previous values. [See](https://opentofu.org/docs/language/values/variables/#variable-definition-precedence)
-

### Output

- Per the [docs](https://opentofu.org/docs/language/values/outputs/): Output values make information about your infrastructure available on the command line, and can expose information for other OpenTofu configurations to use. Output values are similar to return values in programming languages.
- can use `precondition` and `postcondition` here
- there is a `depends_on` key that works like docker compose here
-

### State

- The primary purpose of OpenTofu state is to store bindings between objects in a remote system and resource instances declared in your configuration
- We use `import` to bring in [existing resources](https://opentofu.org/docs/language/import/)
- `terraform_remote_state` [docs](https://opentofu.org/docs/language/state/remote-state-data/#example-usage-remote-backend) look scary at first. I initially read it as lots of "You can do this, but you shouldn't" `terraform_remote_state` can share secrets in it's state file which would be accessible to the other team that maybe shouldn't have it. This is one of those, will my current set up ALWAYS be me and NEVER change. If the answer is yes, then this is a perfectly acceptable way to proceed ... but remember ALWAYS and NEVER are very long times
- [Remote State](https://opentofu.org/docs/language/state/remote/) is what allows us to store a single state file that all members of a team have access to ... similar to what we Daniel set up for Django Commons

### Workspaces

In a [video I watched](https://youtu.be/BZ2TLtf3yFg?si=un-QoHhEaZyiHYwq) a bit of it seemed to imply that workspaces could be used for different environments. Based on the [docs](https://opentofu.org/docs/language/state/workspaces/) that doesn't seem to be true.

I asked Claude and it seems I'm reading it correctly. For separate environments you'd really want to use different directories like `envs/prod` and `envs/staging`. The best use case for workspaces is ephemeral, temporary clones where you want to test something before applying it to prod. Something like

```bash
    tofu workspace new scratch
    tofu apply # throwaway copy, e.g. a test Hetzner server
    tofu destroy
    tofu workspace select default
```

---

## Using openTofu to manage my own infrastructure

I decided to use OpenTofu to manage my own infrastructure to help solidify my learnings. For that I used the following providers:

- AWS
- Coolify
- Digital Ocean
- GitHub
- Hetzner
- TailScale

In my case I'm importing what I already have, not adding new things (yet!).

Here's a quick walkthrough of setting up Hetzner with OpenTofu

1. Created `infra` directory and then `hetzner` directory
2. Created `main.tf` and added the hetzner provider
3. Ran `tofu init`
4. Created `imports.tf` to catalog all of my infrastrcture to import
5. Ran `tofu plan -generate-config-out=generated.tf` which created `generated.tf`. I did have to set the environment variable `HCLOUD_TOKEN` with `set -x HCLOUD_TOKEN (op read "op://token-location")`[ref]I did get a scary warning, "Note: You didn't use the -out option to save this plan, so OpenTofu can't guarantee to take exactly these actions if you run "tofu apply" now." But it seems to be directed more at teams where a server may change while this process is going on. Since I'm all on my own, there's little risk to this warning[/ref]
6. Update each server with to prevent any accidental destruction
	lifecycle {
		ignore_changes = [image, user_data, ssh_keys]
		prevent_destroy = true
	}
7. Encrypt the state file (this was a pita) ... need to get the steps for that

Some caveats:

1. For Hetzner Add `lifecycle { prevent_destroy = true }` to each server.
2. Import your ACL policy, and use `tailscale_device` data sources for all ten machines. Be careful as a bad policy can remove access to the machines
3. Don't allow Coolify to create Hetzner servers as they will collide with the hcloud provider

As things evolved I refactored from having just `main.tf` and `generated.tf` to having the following `*.tf` files:

- dns.tf
- firewalls.tf
- primary_ips.tf
- providers.tf
- rdns.tf
- servers.tf
- ssh_keys.tf
- variables.tf
- versions.tf
- zones.tf

Each one is named so that it matches what resources it's documenting. One thing this lead me to wonder was

> When I run tofu plan or tofu apply, what order do the *.tf files get processed in? Does it matter what I name them?

I did some research, and also asked Claude which responded with:

> Names don't affect the order. OpenTofu loads every .tf file in the directory, merges them into one configuration, and then works out the order from the references between blocks.

Further, per Claude:

  How it works
  - When you run tofu plan or tofu apply, it reads every .tf and .tf.json file in the current
    directory. It doesn't read subdirectories.
  - It reads the files alphabetically, but that has no effect on the result. All the blocks are merged
    as if they were in one file.
  - It then builds a dependency graph from the references between blocks. If hcloud_server.webp1 uses
    hcloud_firewall.firewall.id, the firewall is handled first, wherever each one is defined.
    Resources that don't depend on each other run in parallel, 10 at a time by default.
  - If the graph misses a dependency, you add depends_on. tailscale/keys.tf does this so the ACL is
    applied before the key. Renaming or reordering files never fixes ordering.

  This is why moving the state bucket from main.tf into s3.tf gave a plan with no changes. A
  resource's address is aws_s3_bucket.ardotconsulting_tofu_state no matter which file it's in.

  When file names do matter
  - Override files: files named override.tf or ending in _override.tf are loaded last. Their blocks
    are merged into blocks with the same name instead of being duplicates. Avoid these unless you mean
    to use them.
  - .tofu files: OpenTofu also reads .tofu and .tofu.json. If foo.tofu and foo.tf both exist, it uses
    foo.tofu and ignores foo.tf.
  - Test files: .tftest.hcl and .tofutest.hcl are only used by tofu test.
  - Ignored files: editor temp files, such as names ending in ~ or wrapped in #...#, are skipped. Any
    other extension is ignored, so policy.hujson is read only because file() loads it.
  - Duplicates: a block defined twice is an error, whichever files the two copies are in. That's the
    "Duplicate provider configuration" warning in the checklist.
