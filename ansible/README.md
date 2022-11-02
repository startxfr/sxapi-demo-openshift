# sxapi-demo-openshift playbooks

## Purpose

This directory store playbooks and Ansible environement to help you deploy this demo on
AWS cloud environement.

## Install on your desktop

```bash
cd ~
git clone https://github.com/startxfr/sxapi-demo-openshift.git
cd sxapi-demo-openshift/ansible
``` 

## Configure

First, you must set deployement configuration using the config.yml file. Please review it
and make relevant changes, especially project.* and aws.ec2.image .


## Provision on AWS

```bash
ansible-playbook -i inventory playbooks/provision_aws.yml
```

## Install Openshift

```bash
ansible-playbook -i inventory playbooks/install_paas.yml
```

## Install Application

```bash
ansible-playbook -i inventory playbooks/install_apps.yml
```

## Test Application

You must connect to ``https://master0.<project.name>.<project.dns_zone>:8443``

## Deprovision on AWS (remove all)

```bash
ansible-playbook -i inventory playbooks/deprovision_aws.yml
```