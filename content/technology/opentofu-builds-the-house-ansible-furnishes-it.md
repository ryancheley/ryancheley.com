Title: OpenTofu builds the house, Ansible furnishes it
Date: 2026-11-10
Author: ryan
Tags: iac, Ansible, infrastructure-as-code
Slug: opentofu-builds-the-house-ansible-furnishes-it
Series: learnings-on-leave
Status: draft

If [OpenTofu](https://opentofu.org/) is the thing that builds your infrastructure, [Ansible](https://docs.Ansible.com/) is the thing that configures it. While there is some overlap between the 2 you should have each set of code do it's own thing.

I think about OpenTofu as the construction team that builds the house, while Ansible is the team the puts the stuff inside (appliances, furniture, decorations, etc). That is, OpenTofu will build the server, and Ansible will configure it.

As I worked through learning Ansible I watched some videos, and did some tutorials. But what really worked for me to learn it was to identify what I want to have installed and configured on any new server.

To that end, the things I want the most out of a new server are:

1. Require environment variables
2. Update apt cache and upgrade packages

<!-- 1. add to my tailnet
2. make sure everything is updated after initial build
3. make sure that what i need is installed (docker, other things, atuin, fish, claude?)
4. add user(s) that are locked down
5. install my dot files
6. ensure ssh is closed off and the server is only accessible via my tailnet and root user -->

In order to do this, there are 9 different modules that need to be used.

Below, I'll walk through my initial playbook step by step, with a final version of it. [ref]You can also use Ansible to perform updates on your server (which is actually why I wanted to learn Ansible initially) but coolify has a setting to do automatic updates on servers, so I'm leaving that to coolify to complete.[/ref]

The commands I used were (add doc link for each of them with a short explanation of what the command does):

1. Ansible.builtin.assert
2. Ansible.builtin.apt
3. Ansible.builtin.hostname
4. Ansible.builtin.user
5. Ansible.builtin.copy
6. Ansible.builtin.deb822_repository
7. Ansible.builtin.command
8. Ansible.builtin.service
9. Ansible.posix.authorized_key
10. community.general.timezone

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

I created a `.env` file to hold various secrets. In order to access them I set up a `vars` key like this:

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

## Ansible.builtin.assert

This module asserts that a given expression is true. In order to require envoronment variables, we have to assert that their length is greatn than 0. To do this I have this block:

```yaml
- name: Require environment variables
    ansible.builtin.assert:
    that:
        - username | length > 0
        - user_password | length > 0
        - ts_authkey | length > 0
    fail_msg: BOOTSTRAP_USERNAME, BOOTSTRAP_PASSWORD, and TS_AUTHKEY must be set (run via op run --env-file=.env)
```

Because we set up the variables in the setup step above, this is just ensuring that the data read from the environment variables are present.

## Ansible.builtin.apt

This module manages apt-packages. Since my server is running Ubuntu I can use apt for package management. If you're using a different distro you'll want to change this to use it's package manager

```yaml
- name: Update apt cache and upgrade packages
    ansible.builtin.apt:
    update_cache: true
    upgrade: dist
```

There are two parameters defined here:

1. update_cache: This is the same as running apt-get update before the operation
2. upgrade: This will perform an aptitude safe-upgrade

## Ansible.builtin.hostname

This module manages the hostname for the server

```yaml
- name: Set hostname
    ansible.builtin.hostname:
    name: "{{ inventory_hostname }}"
```

You'll notice here that the name is set to `"{{ inventory_hostname }}"`. The hostname that is being used is stored in my inventory file (more on that later). This prevents hardcoding the hostname and having a potential hostname collision on servers.

## Ansible.builtin.user

The user module manages user accounts.

```yaml
- name: Create a user
    ansible.builtin.user:
    name: "{{ username }}"
    groups: sudo
    append: true
    shell: /bin/bash
    create_home: true
    password: "{{ user_password | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }}"
```

The command above will create the user specified in the environment variables, add them to the sudo group, set their shell to bash and create a home directory for them. It will also set the password for the user and hash it with sha512. The append parameter is allowing the user to be appended to the `sudo` groups.

If it was set to false then on each run if a user was added to other groups (either manually on the server OR via a task in a different playbook, or a task before) they would be removed from those groups.

## Ansible.builtin.copy

The copy module will copy files to remote locations. This is like both `scp` and `rsync`. This builtin uses SFTP or SCP to move the file. The `ssh_transfer_method` (configured in the `ansible.cfg` file ... more on that later) setting controls which one.

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

There are several parameters here. The `src` defaults to looking at the `files` directory. The `dest` indicates where the file will be copied to. The `validate` parameter ensures that the file coped over is valid which prevents bad things from being able to happen when copying over the config file.

The `notify` <thing> checks a handler which is defined later.

## Ansible.builtin.deb822_repository

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

Here I'm adding tailscale to the server. The `{{ release }}` was defined in the `vars` setup above and allows me to get the correct version of tailscale for the version of Ubuntu that I'm running.

## Ansible.builtin.command

This module allows you to run a command on a target machine. I used a few of them for my setup

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

Above there is a command to check the status of tailscale on the server. The output is saved into a variable called `ts_status` which is then used to check the state of tailscale. If it's not running then tailscale will be enabled using the `{{ ts_authkey }}` that was defined above in the `vars` section.

## Ansible.builtin.service

The service module manages services on remote hosts.

```yaml
  handlers:
    - name: Reload ssh
      ansible.builtin.service:
        name: ssh
        state: reloaded
```

Here I'm creating a handler (which was referenced above in `Copy ssh configuration` task which used the `ansible.builtin.copy` topic).

This handler will reload ssh if a new configuration was added / copied to the remote host. The name here has to match the `notify` parameter exactly in order for it to be called.

## Ansible.posix.authorized_key

This will add or remove an SSH Authorized Key to allow passwordless entry into a server.

```yaml
- name: Add SSH to user
    ansible.posix.authorized_key:
    user: "{{ username }}"
    state: present
    key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
```

Here I'm setting user and copying the `id_ed25519.pub` to the server so that `{{ username }}` can just ssh into the server without the use of a password.

## community.general.timezone

This allows you to configure the timezone setting for the remote host.

```yaml
- name: Set timezone to America/Los_Angeles
    become: true
    community.general.timezone:
    name: America/Los_Angeles
```

Since I live in the `America/Los_Angeles` timezone, I'm setting the server timezone to match me.

## Full Playbook

When you put it all together, this is what my full playbook looks like

<!-- [[[cog
import cog
import httpx2
response = httpx2.get('https://raw.githubusercontent.com/ryancheley/infra/refs/heads/main/ansible/bootstrap.yml?token=GHSAT0AAAAAACAG7UW5QQSZU7YPZJ3HWUFK2XTOFGA')
output = f'```\n{response.text}\n```'
cog.outl(output)
]]] -->
```
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
    - name: Create a user
      ansible.builtin.user:
        name: "{{ username }}"
        groups: sudo
        append: true
        shell: /bin/bash
        create_home: true
        # Per-host stable salt keeps this idempotent while still syncing password changes from 1Password.
        password: "{{ user_password | password_hash('sha512', 65534 | random(seed=inventory_hostname) | string) }}"
      no_log: true
    - name: Add SSH to user
      ansible.posix.authorized_key:
        user: "{{ username }}"
        state: present
        key: "{{ lookup('file', '~/.ssh/id_ed25519.pub') }}"
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

## Other needed files:

The playbook defines WHAT is going to be done, but there are some supporting files that need to be set up as well

### ansible.cfg

The `ansible.cfg` file sets the configuration for ansible. Some of the items you can define is where the inventory file to be used is located (by default it's at `/etc/hosts/ansible`). It can also be used to indicate the location of the python interpreter.

My file looks like this

```cfg
[defaults]
inventory = inventory.ini
interpreter_python = /usr/bin/python3
```

### inventory.ini

The inventory.ini file defines the inventory of remote hosts that you'll be interacting with. It allows you to give them a short name and then define the hostname, the host IP Address, and the user to be used when logging in

My file looks like this:

```ini
[lab]
h-ansible-p-001 ansible_host=IP_ADDRESS ansible_user=root
```

### requirements.yml

Some of the modules I invoke above aren't available in the standard library for Ansible (the `community` and `posix` ones in particular). In order to make them available you need to add them to your `requirements.yml` file.

My file looks like this

```yaml
collections:
    - name: ansible.posix
    - name: community.general
```

## Running the playbook

With the playbook and the support files now ready, we can use `ansible-playbook bootstrap.yml` to run the playbook. Of course, since I'm a big fan of [just](https://ryancheley.com/2026/10/26/have-you-heard-the-good-news-about-just/) I created a few just recipes

```just
[group('ansible')]
[working-directory('ansible')]
run-playbook *args:
    uvx ansible-playbook {{ args }}

[group('ansible')]
[working-directory('ansible')]
lint *args:
    ANSIBLE_DEPRECATION_WARNINGS=False uvx ansible-lint --project-dir . {{ args }}

```

The first command `just run-playbook bootstrap.yml` will run the playbook. It will also run any other playbooks that I need.

The second command `just lint` will lint the file and make sure it's formatted correctly.


## What I learned

This was a really good learning experience. A few things that I learned

- You can pass multiple inventory files (https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#passing-multiple-inventory-sources) e.g. `ansible-playbook get_logs.yml -i staging -i production`
- You can split inventory files into logical groupings and then drop them into a directory (like `inventory`) and then reference the directory instead of a specific inventory file (https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#organizing-inventory-in-a-directory)
- you can add host ranges (https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html#adding-ranges-of-hosts)
- A good rule of thumb is that anything you'd click in a cloud console belongs in Terraform/OpenTofu, and anything you'd do after SSHing in belongs in Ansible.

Initially I ran through a tuturial to help get me oriented to Ansible, but I found that I really wanted to have a playbook that would do the things that I **wanted** to have done. It was at that point that I outlined what I would want on a server and started to construct a playbook based on that.

## Conclusion

There are so many potential modules to use, but I think the best way to start applying them is to figure out what problem you need to solve and then reach for the module that helps you solve that.

Ansible has a lot of potential for my future workflows and I'm looking forward to incorporating these learnings into those work flows.

One wild idea I have is to create a GitHub repo, commit a Django project to that repo and then have OpenTofu create whatever resources it needs, ansible to configure any remote hosts that are required, and Coolify to automatically deploy this project. I really think that this will help to get a project up and running really quickly.
