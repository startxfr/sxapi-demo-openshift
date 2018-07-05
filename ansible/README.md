# Ansible playbooks for sxapi-demo-openshift

## Using Ansible to install Openshift

cf. [Installation Readme file](../INSTALL.md) and the shell [script](../openshift-install) used to perform the installation.

If you don't use this install on a cloud provider's dynamically created instance, __you must define your target IP address in `inventory/all` file__.

Your system 

Ansible execution being highly dependent on the Python version your system is using, 
potentially on some additional Python dependencies, a bash script is provided that set up the Python environment and install Ansible with the expected version.

Use `./setup.sh` to run the `sxapi-demo-openshift` with Ansible

Alternatively you can try your luck with your local Ansible install and run:
`ansible-playbook setup.yml` 

### Variables
Place the values of the necessary variables in `inventory/groups_vars/domain-host.yml`.

If you need this file encrypted and commited to your repo, create the file and use `ansible-vault encrypt inventory/groups_vars/domain-host.yml`, then edit it with `ansible-vault edit inventory/groups_vars/domain-host.yml`

You can create a `vault-pass.donotcommit` file at the ansible project root for convenience. `ansible.cfg` has a directive that will look for this file to get the vault password.

See `inventory/groups_vars/domain-host.yml.example` for a file example.

#### List of necessary variables

| Variable name | Usage |
| ------------- | ------------- |
|        default_user       | the target system must have a password-less sudo user to execute the playbooks. |
|               |  |


