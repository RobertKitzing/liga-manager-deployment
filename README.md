# Liga Manager Deployment

This repository contains scripts and config templates for deploying
services at [Wilde Liga Bremen](https://www.wildeligabremen.de).

## Requirements

```bash
# A recent open-source version of ansible (2.x versions are fine)
$ sudo apt install ansible
```

## Usage examples

```bash
# Setup a new server
$ ansible-playbook -i inventory/production setup.yml

# Deploy services
$ ansible-playbook -i inventory/production --vault-password-file vault-password deploy.yml

# Rolling upgrade
$ ansible-playbook -i inventory/production rolling-upgrade.yml
```

## How set up a new server

* Create a VM with a recent version of Ubuntu Linux at any hosting provider
* Add your SSH public key to root user's `authorized_keys` file
* Add the public IPv4 address to inventory file
* Set up the server using `setup.yml`
* Make sure you have access to the vault password for decrypting secrets
* You can write the password to a file named `vault-password` or use `--ask-vault-password` to enter it every time you deploy
* Execute a deployment using `deploy.yml`

## How to deploy

* A deployment updates one or more docker containers to a more recent version
* Update versions in `vars/production`
* If you only need to update versions of `ui` or `api` container, then use `rolling-upgrade.yml`
* If you need to update `mariadb`, `nginx` or `redis`, then use `deploy.yml`
* If everything went fine, commit the changes to the repository

## Maintenance modes

### Wordpress

Use the following commands inside the `wordpress` container.

```bash
# Enable
$ echo '<?php $upgrading = time(); ?>' > .maintenance

# Disable
$ rm .maintenance
```

### Liga Manager

Use the following commands inside the `api` container.

```bash
# Enable
$ lima app:maintenance --mode=on

# Disable
$ lima app:maintenance --mode=off
```