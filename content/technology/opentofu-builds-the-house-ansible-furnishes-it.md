Title: OpenTofu builds the house, Ansible furnishes it
Date: 2026-11-16
Author: ryan
Tags: iac, Ansible, infrastructure-as-code
Slug: opentofu-builds-the-house-ansible-furnishes-it
Series: learnings-on-leave
Status: published

If [OpenTofu](https://opentofu.org/) is the thing that builds your infrastructure, [Ansible](https://docs.ansible.com/) is the thing that configures it. While there is some overlap between the two, you should have each set of code do its own thing.

I think about OpenTofu as the construction team that builds the house, while Ansible is the team that puts the stuff inside (appliances, furniture, decorations, etc.). That is, OpenTofu will build the server, and Ansible will configure it.

As I worked through learning Ansible, I watched some videos and did some tutorials. But what really worked for me to learn it was to identify what I want to have installed and configured on any new server.

To that end, the things I want the most out of a new server are:

1. Add it to my tailnet
2. Make sure everything is updated after the initial build
3. Make sure the tools I need are installed (Docker, Atuin, fish, etc.)
4. Add user(s) that are locked down
5. Install my dotfiles
6. Ensure SSH is closed off and the server is only accessible via my tailnet

The playbook below covers all six (plus setting the hostname and timezone), with one assist from OpenTofu: closing off public SSH for item 6 is done with a cloud firewall rather than in Ansible. The one exception is Docker: Coolify installs it when it sets up a server, so I leave that to Coolify.

In order to do this, I used 12 different modules.

Below, I'll walk through my initial playbook step by step, with a final version of it. [ref]You can also use Ansible to keep your server updated over time (which is actually why I wanted to learn Ansible initially), but Coolify has a setting to do automatic updates on servers, so I'm leaving ongoing updates to Coolify. The playbook only does a one-time upgrade when the server is first bootstrapped.[/ref]

The modules I used were:

1. [ansible.builtin.assert](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/assert_module.html#ansible-collections-ansible-builtin-assert-module)
2. [ansible.builtin.apt](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/apt_module.html#ansible-collections-ansible-builtin-apt-module)
3. [ansible.builtin.hostname](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/hostname_module.html#ansible-collections-ansible-builtin-hostname-module)
4. [ansible.builtin.user](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/user_module.html#ansible-collections-ansible-builtin-user-module)
5. [ansible.builtin.copy](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/copy_module.html#ansible-collections-ansible-builtin-copy-module)
6. [ansible.builtin.deb822_repository](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/deb822_repository_module.html#ansible-collections-ansible-builtin-deb822-repository-module)
7. [ansible.builtin.command](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/command_module.html#ansible-collections-ansible-builtin-command-module)
8. [ansible.builtin.service](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/service_module.html#ansible-collections-ansible-builtin-service-module)
9. [ansible.posix.authorized_key](https://docs.ansible.com/projects/ansible/latest/collections/ansible/posix/authorized_key_module.html)
10. [community.general.timezone](https://docs.ansible.com/projects/ansible/latest/collections/community/general/timezone_module.html)
11. [ansible.builtin.unarchive](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/unarchive_module.html#ansible-collections-ansible-builtin-unarchive-module)
12. [ansible.builtin.git](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/git_module.html#ansible-collections-ansible-builtin-git-module)

## The Setup

The Ansible playbook I created had the following format:

```yaml
- name:
  hosts:
  vars:
  tasks:
    - name:
      module:
        parameters:
  handlers:
    - name:
      module:
        parameters:
```

I created a `.env` file to hold various secrets. In order to access them, I set up a `vars` key like this:

```yaml
- name: Bootstrap server
  hosts: lab
  vars:
    username: "{{ lookup('env', 'BOOTSTRAP_USERNAME') }}"
    user_password: "{{ lookup('env', 'BOOTSTRAP_PASSWORD') }}"
    ts_authkey: "{{ lookup('env', 'TS_AUTHKEY') }}"
    release: "{{ ansible_facts['distribution_release'] }}"
```

Each of the blocks below would go under the `tasks` key from above.

## ansible.builtin.assert

This module asserts that a given expression is true. In order to require environment variables, we have to assert that their length is greater than 0. To do this I have this block:

```yaml
- name: Require environment variables
  ansible.builtin.assert:
    that:
      - username | length > 0
      - user_password | length > 0
      - ts_authkey | length > 0
    fail_msg: BOOTSTRAP_USERNAME, BOOTSTRAP_PASSWORD, and TS_AUTHKEY must be set (run via op run --env-file=.env)
```

Because we set up the variables in the setup step above, this is just ensuring that the data read from the environment variables is present.

## ansible.builtin.apt

This module manages apt packages. Since my server is running Ubuntu, I can use apt for package management. If you're using a different distro, you'll want to change this to use its package manager.

```yaml
- name: Update apt cache and upgrade packages
  ansible.builtin.apt:
    update_cache: true
    upgrade: dist
```

There are two parameters defined here:

1. `update_cache`: This is the same as running `apt-get update` before the operation
2. `upgrade`: Setting this to `dist` runs `apt-get dist-upgrade`, which upgrades all packages and will add or remove dependencies if needed

I also use `apt` to install the tools I want on every server:

```yaml
- name: Install tools
  ansible.builtin.apt:
    name: [fish, git, direnv]
    state: present
```

## ansible.builtin.hostname

This module manages the hostname for the server.

```yaml
- name: Set hostname
  ansible.builtin.hostname:
    name: "{{ inventory_hostname }}"
```

You'll notice here that the name is set to `"{{ inventory_hostname }}"`. The hostname that is being used is stored in my inventory file (more on that later). This prevents hardcoding the hostname and having a potential hostname collision on servers.

## ansible.builtin.user

The user module manages user accounts.

```yaml
- name: Create a user
  ansible.builtin.user:
    name: "{{ username }}"
    groups: sudo
    append: true
    shell: /usr/bin/fish
    create_home: true
    password: "{{ user_password | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }}"
  no_log: true
```

The command above will create the user specified in the environment variables, add them to the sudo group, set their shell to fish (installed in an earlier task) and create a home directory for them. It will also set the password for the user and hash it with sha512. The `append` parameter adds the user to the `sudo` group without removing them from any other groups.

If it were set to `false`, then on each run the user would be removed from any other groups they'd been added to (either manually on the server OR via a task in a different playbook, or a task before).

The `no_log: true` keeps Ansible from printing the task's arguments (including the password hash) in its output.

## ansible.builtin.copy

The copy module will copy files to remote locations, similar to `scp` or `rsync`. Under the hood it uses SFTP or SCP to move the file, controlled by the `transfer_method` setting in the `[ssh_connection]` section of `ansible.cfg`. The default, `smart`, tries SFTP first and falls back to SCP, so I didn't need to set it.

```yaml
- name: Copy ssh configuration
  ansible.builtin.copy:
    src: 10-hardening.conf
    dest: /etc/ssh/sshd_config.d/
    owner: root
    group: root
    mode: "0644"
    validate: /usr/sbin/sshd -t -f %s
  notify: Reload ssh
```

There are several parameters here. The `src` defaults to looking at the `files` directory. The `dest` indicates where the file will be copied to. The `validate` parameter ensures that the file copied over is valid, which prevents a broken config from locking you out.

The `notify` task keyword triggers a handler which is defined later.

## ansible.builtin.deb822_repository

This module will add and remove [deb822 formatted](https://repolib.readthedocs.io/en/latest/deb822-format.html) repositories.

```yaml
- name: Add repository
  ansible.builtin.deb822_repository:
    name: tailscale
    types: deb
    uris: https://pkgs.tailscale.com/stable/ubuntu
    suites: "{{ release }}"
    components: main
    signed_by: https://pkgs.tailscale.com/stable/ubuntu/{{ release }}.noarmor.gpg
```

Here I'm adding the Tailscale apt repository to the server. The `{{ release }}` was defined in the `vars` setup above and allows me to get the correct version of Tailscale for the version of Ubuntu that I'm running.

With the repository in place, Tailscale can be installed using the `apt` module from earlier:

```yaml
- name: Install tailscale
  ansible.builtin.apt:
    name: tailscale
    state: present
    update_cache: true
```

Setting `update_cache: true` is important here so apt picks up the newly added repository before trying to install from it.

## ansible.builtin.command

This module allows you to run a command on a target machine. I used it a few times in my setup.

```yaml
- name: Check tailscale status
  ansible.builtin.command: tailscale status --json
  register: ts_status
  changed_when: false
  failed_when: false
  check_mode: false
- name: Join tailnet
  ansible.builtin.command: tailscale up --authkey={{ ts_authkey }}
  when: (ts_status.stdout | from_json).BackendState != 'Running'
  no_log: true
  changed_when: true
```

Above there is a command to check the status of Tailscale on the server. The output is saved into a variable called `ts_status` which is then used to check the state of Tailscale. If it's not running, the server joins the tailnet using the `{{ ts_authkey }}` that was defined above in the `vars` section.

One caveat: if the `tailscaled` service isn't running yet, `tailscale status --json` returns nothing and the `from_json` filter will fail. In practice the apt install starts the service, so this hasn't bitten me.

## ansible.builtin.service

The service module manages services on remote hosts.

```yaml
handlers:
  - name: Reload ssh
    ansible.builtin.service:
      name: ssh
      state: reloaded
```

Here I'm creating a handler (which was referenced above in the `Copy ssh configuration` task in the `ansible.builtin.copy` section).

This handler will reload ssh if a new configuration was copied to the remote host. The name here has to match the `notify` parameter exactly in order for it to be called.

## ansible.posix.authorized_key

This module adds or removes an SSH authorized key to allow passwordless entry into a server.

```yaml
- name: Add SSH to user
  ansible.posix.authorized_key:
    user: "{{ username }}"
    state: present
    key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
```

Here I'm setting the user and copying the `id_ed25519.pub` to the server so that `{{ username }}` can just SSH into the server without the use of a password.

## community.general.timezone

This allows you to configure the timezone setting for the remote host.

```yaml
- name: Set timezone to America/Los_Angeles
  become: true
  community.general.timezone:
    name: America/Los_Angeles
```

Since I live in the `America/Los_Angeles` timezone, I'm setting the server timezone to match me.

The `become: true` isn't actually needed here, since the inventory connects as `root` and every task already runs with root privileges. It would matter if you connected as a non-root user, in which case you'd want `become: true` at the play level rather than on a single task.

## ansible.builtin.unarchive

This module unpacks an archive, optionally downloading it first. Fish, git, and direnv are installed with `apt`, but [Starship](https://starship.rs/) and [Atuin](https://atuin.sh/) aren't packaged for Ubuntu. Both projects publish prebuilt binaries on GitHub, so I download and extract them directly:

```yaml
- name: Install starship
  ansible.builtin.unarchive:
    src: "https://github.com/starship/starship/releases/latest/download/starship-{{ ansible_facts['architecture'] }}-unknown-linux-musl.tar.gz"
    dest: /usr/local/bin
    remote_src: true
    creates: /usr/local/bin/starship
- name: Install atuin
  ansible.builtin.unarchive:
    src: "https://github.com/atuinsh/atuin/releases/latest/download/atuin-{{ ansible_facts['architecture'] }}-unknown-linux-musl.tar.gz"
    dest: /usr/local/bin
    remote_src: true
    extra_opts: [--strip-components=1, --wildcards, "*/atuin"]
    creates: /usr/local/bin/atuin
```

There are a few parameters worth calling out:

1. `remote_src`: Tells Ansible the archive is fetched by the server itself rather than copied from my machine
2. `{{ ansible_facts['architecture'] }}`: Resolves to `x86_64` or `aarch64`, which matches the names of the release files, so this works on ARM servers too
3. `extra_opts`: The Atuin archive wraps the binary in a directory (along with a README and license), so these `tar` options pull out just the `atuin` binary
4. `creates`: Skips the task if the binary already exists, which keeps the playbook idempotent. The trade-off is that Ansible won't upgrade either tool; to update, delete the binary and re-run the playbook

I could have piped each project's install script to `sh` instead, but those scripts can modify shell configuration files, which would fight with my dotfiles.

## ansible.builtin.git

This module manages git checkouts. My [dotfiles](https://github.com/ryancheley/dotfiles) live in a public GitHub repo, and its `setup.sh` script symlinks each config into `~/.config`.

```yaml
- name: Clone dotfiles
  ansible.builtin.git:
    repo: https://github.com/ryancheley/dotfiles.git
    dest: "/home/{{ username }}/code/dotfiles"
    version: main
  become: true
  become_user: "{{ username }}"
- name: Link dotfiles
  ansible.builtin.command: ./setup.sh
  args:
    chdir: "/home/{{ username }}/code/dotfiles"
    creates: "/home/{{ username }}/.config/fish"
  become: true
  become_user: "{{ username }}"
```

The `become_user` parameter runs both tasks as the user created earlier, so the files belong to them rather than `root`. Since `version` is set to `main`, each run pulls the latest commits, and because `setup.sh` creates symlinks the changes show up immediately.

The second task uses the `command` module from earlier. The `creates` parameter means `setup.sh` only runs once, when `~/.config/fish` doesn't exist yet.

## Closing off public SSH (with OpenTofu)

My first version of this playbook used Ansible's `community.general.ufw` module to only allow SSH over my tailnet. I took it out for two reasons. First, I already manage my server firewalls with OpenTofu, and having two tools in charge of who can reach port 22 is a recipe for confusion. Second, Docker writes its own firewall rules, so any port a container publishes skips UFW entirely, which matters on a Coolify server.

A firewall is part of building the house, not furnishing it, so it belongs in OpenTofu:

```hcl
resource "hcloud_firewall" "tailnet_only" {
  name = "tailnet-only-firewall"
  rule {
    direction  = "in"
    protocol   = "icmp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    description = "Tailscale direct connections"
    direction   = "in"
    port        = "41641"
    protocol    = "udp"
    source_ips  = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    port       = "80"
    protocol   = "tcp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
  rule {
    direction  = "in"
    port       = "443"
    protocol   = "tcp"
    source_ips = ["0.0.0.0/0", "::/0"]
  }
}
```

There's no rule for port 22. SSH over Tailscale travels inside an encrypted WireGuard tunnel, so the cloud firewall never sees it as SSH traffic.

The catch is that Ansible needs public SSH the first time, before the server has joined my tailnet. So a new server goes through three steps:

1. OpenTofu creates the server with a firewall that allows SSH
2. Ansible runs the bootstrap playbook, which joins the server to my tailnet
3. I switch the server to the `tailnet_only` firewall and run `tofu apply`

From then on, the server is only reachable over SSH through my tailnet. Since Coolify manages servers over SSH, the server also needs to be added to Coolify using its tailnet address.

## Full Playbook

When you put it all together, this is what my full playbook looks like:

<!-- [[[cog
import cog
import subprocess
text = subprocess.run(
    ["gh", "api", "repos/ryancheley/infra/contents/ansible/bootstrap.yml",
     "-H", "Accept: application/vnd.github.raw"],
    capture_output=True, text=True, check=True,
).stdout
cog.outl(f"```yaml\n{text.rstrip()}\n```")
]]] -->
```yaml
- name: Bootstrap server
  hosts: lab
  vars:
    # Injected by `op run --env-file=.env`; nothing user-specific lives in the repo.
    username: "{{ lookup('env', 'BOOTSTRAP_USERNAME') }}"
    user_password: "{{ lookup('env', 'BOOTSTRAP_PASSWORD') }}"
    ts_authkey: "{{ lookup('env', 'TS_AUTHKEY') }}"
    release: "{{ ansible_facts['distribution_release'] }}"
  tasks:
    - name: Require environment variables
      ansible.builtin.assert:
        that:
          - username | length > 0
          - user_password | length > 0
          - ts_authkey | length > 0
        fail_msg: BOOTSTRAP_USERNAME, BOOTSTRAP_PASSWORD, and TS_AUTHKEY must be set (run via op run --env-file=.env)
    - name: Update apt cache and upgrade packages
      ansible.builtin.apt:
        update_cache: true
        upgrade: dist
    - name: Set hostname
      ansible.builtin.hostname:
        name: "{{ inventory_hostname }}"
    - name: Install tools
      ansible.builtin.apt:
        name: [fish, git, direnv]
        state: present
    - name: Install starship
      ansible.builtin.unarchive:
        src: "https://github.com/starship/starship/releases/latest/download/starship-{{ ansible_facts['architecture'] }}-unknown-linux-musl.tar.gz"
        dest: /usr/local/bin
        remote_src: true
        creates: /usr/local/bin/starship
    - name: Install atuin
      ansible.builtin.unarchive:
        src: "https://github.com/atuinsh/atuin/releases/latest/download/atuin-{{ ansible_facts['architecture'] }}-unknown-linux-musl.tar.gz"
        dest: /usr/local/bin
        remote_src: true
        extra_opts: [--strip-components=1, --wildcards, "*/atuin"]
        creates: /usr/local/bin/atuin
    - name: Create a user
      ansible.builtin.user:
        name: "{{ username }}"
        groups: sudo
        append: true
        shell: /usr/bin/fish
        create_home: true
        # Per-host stable salt keeps this idempotent while still syncing password changes from 1Password.
        password: "{{ user_password | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }}"
      no_log: true
    - name: Add SSH to user
      ansible.posix.authorized_key:
        user: "{{ username }}"
        state: present
        key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
    - name: Clone dotfiles
      ansible.builtin.git:
        repo: https://github.com/ryancheley/dotfiles.git
        dest: "/home/{{ username }}/code/dotfiles"
        version: main
      become: true
      become_user: "{{ username }}"
    - name: Link dotfiles
      ansible.builtin.command: ./setup.sh
      args:
        chdir: "/home/{{ username }}/code/dotfiles"
        creates: "/home/{{ username }}/.config/fish"
      become: true
      become_user: "{{ username }}"
    - name: Copy ssh configuration
      ansible.builtin.copy:
        src: 10-hardening.conf
        dest: /etc/ssh/sshd_config.d/
        owner: root
        group: root
        mode: "0644"
        validate: /usr/sbin/sshd -t -f %s
      notify: Reload ssh
    - name: Add repository
      ansible.builtin.deb822_repository:
        name: tailscale
        types: deb
        uris: https://pkgs.tailscale.com/stable/ubuntu
        suites: "{{ release }}"
        components: main
        signed_by: https://pkgs.tailscale.com/stable/ubuntu/{{ release }}.noarmor.gpg
    - name: Install tailscale
      ansible.builtin.apt:
        name: tailscale
        state: present
        update_cache: true
    - name: Check tailscale status
      ansible.builtin.command: tailscale status --json
      register: ts_status
      changed_when: false
      failed_when: false
      check_mode: false
    - name: Join tailnet
      ansible.builtin.command: tailscale up --authkey={{ ts_authkey }}
      when: (ts_status.stdout | from_json).BackendState != 'Running'
      no_log: true
      changed_when: true
    - name: Set timezone to America/Los_Angeles
      become: true
      community.general.timezone:
        name: America/Los_Angeles
  handlers:
    - name: Reload ssh
      ansible.builtin.service:
        name: ssh
        state: reloaded
```
<!-- [[[end]]] -->

## Other needed files

The playbook defines *what* is going to be done, but there are some supporting files that need to be set up as well.

### ansible.cfg

The `ansible.cfg` file sets the configuration for Ansible. Some of the items you can define are where the inventory file to be used is located (by default it's at `/etc/ansible/hosts`). It can also be used to indicate the location of the Python interpreter.

My file looks like this:

```cfg
[defaults]
inventory = inventory.ini
interpreter_python = /usr/bin/python3
```

### inventory.ini

The `inventory.ini` file defines the inventory of remote hosts that you'll be interacting with. It allows you to give them a short name and then define the hostname, the host IP address, and the user to be used when logging in.

Because public SSH is closed off once the server moves to the tailnet-only firewall, the inventory entry changes after the first run. The first time, Ansible has to connect to the server's public IP:

```ini
[lab]
h-ansible-p-001 ansible_host=IP_ADDRESS ansible_user=root
```

After that, the server is only reachable over the tailnet. The playbook sets the hostname before joining the tailnet, so Tailscale's MagicDNS knows the server as `h-ansible-p-001`. Dropping `ansible_host` makes Ansible connect using that name:

```ini
[lab]
h-ansible-p-001 ansible_user=root
```

### requirements.yml

Some of the modules I invoke above aren't included in `ansible-core` (the `community` and `posix` ones in particular). In order to make them available you need to add them to your `requirements.yml` file.

My file looks like this:

```yaml
collections:
    - name: ansible.posix
    - name: community.general
```

Then install them with:

```bash
uvx --from ansible-core ansible-galaxy collection install -r requirements.yml
```

## Running the playbook

With the playbook and the support files now ready, we can use `ansible-playbook bootstrap.yml` to run the playbook. Of course, since I'm a big fan of [just](https://ryancheley.com/2026/10/26/have-you-heard-the-good-news-about-just/), I created a few just recipes:

```just
[group('ansible')]
[working-directory('ansible')]
run-playbook *args:
    op run --env-file=.env -- uvx --from ansible-core ansible-playbook {{ args }}

[group('ansible')]
[working-directory('ansible')]
lint *args:
    ANSIBLE_DEPRECATION_WARNINGS=False uvx ansible-lint --project-dir . {{ args }}

```

The first recipe, `just run-playbook bootstrap.yml`, runs the bootstrap playbook. Since it passes any arguments straight through to `ansible-playbook`, I can use the same recipe for any other playbook I write (e.g. `just run-playbook other.yml --check`).

The second recipe, `just lint`, lints the playbook and makes sure it's formatted correctly.

## What I learned

This was a really good learning experience. A few things that I learned:

- You can [pass multiple inventory files](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#passing-multiple-inventory-sources), e.g. `ansible-playbook get_logs.yml -i staging -i production`
- You can split inventory files into logical groupings and then drop them into a directory (like `inventory`) and then [reference the directory](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#organizing-inventory-in-a-directory) instead of a specific inventory file
- You can add [host ranges](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#adding-ranges-of-hosts)
- A good rule of thumb is that anything you'd click in a cloud console belongs in Terraform/OpenTofu, and anything you'd do after SSHing in belongs in Ansible.

Initially I ran through a tutorial to help get me oriented to Ansible, but I found that I really wanted to have a playbook that would do the things that I **wanted** to have done. It was at that point that I outlined what I would want on a server and started to construct a playbook based on that.

## Conclusion

There are so many potential modules to use, but I think the best way to start applying them is to figure out what problem you need to solve and then reach for the module that helps you solve that.

Ansible has a lot of potential for my future workflows and I'm looking forward to incorporating these learnings into them.

One wild idea I have is to create a GitHub repo, commit a Django project to that repo, and then have OpenTofu create whatever resources it needs, Ansible to configure any remote hosts that are required, and Coolify to automatically deploy this project. I think that this will help to get a project up and running really quickly.
