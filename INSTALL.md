# Openshift installation

To run this demo you need to have a 
[Red Hat Openshift Container Plateform](https://www.redhat.com/fr/technologies/cloud-computing/openshift) cluster, an [Openshift Origin](https://www.openshift.org) cluster,
or an [Openshift Online](https://manage.openshift.com) account.<br>
This section will help you for Online and Origin setup. Red Hat Container Plateform require an
active subscription. You can contact our [Consulting team](https://www.startx.fr/contact) to obtain a free subscription for
testing this product.

## Setup Openshift Online environement

[Openshift Online](https://manage.openshift.com) deliver SaaS Openshift plateform with free and paid options.
You can use it to get a running PaaS within the next minutes. Will there is severals constraints 
(advanced features access, RBAC, Resources, Storage, DNS) this solution is the easyest way to run test, demo or
POC showcase.

- Create a [Red Hat developper Account](https://developers.redhat.com) or access [Red Hat portal](https://sso.redhat.com/auth/realms/redhat-external/protocol/saml/clients/legacy-idp-servlets) using your existing credentials.
- If you don't have a Red Hat account, you can [create it now](https://developers.redhat.com/auth/realms/rhd/login-actions/authenticate?client_id=oso)
- Validate your account (e-mail validation + login to the openshift online web-console)
- Under your openshift origin panel, choose "Add new Plan"
- Choose "Free plan", then next
- Under cluster region, choose your closest region, then next. Confirm this setup and create.
- After several second, your Openshift environement will be up and available. You can then connect to the Console by clicking on "Open web console"


## Setup Openshift Origin environement (AWS environement)

### Setup demo environement in AWS

Require knowledge of [AWS services](https://aws.amazon.com) (especialy EC2, VPC, Route53) and full access to 
EC2, VPC and Route53 services. Your AWS account must be billable and you must have access to a domain hostZone.

These instruction will help you setup an openshift single instance on an AWS EC2 instance responding to a public sub-domain
of your corporation or entity.

#### VPC network configuration

You must setup the following resources under you AWS VPC cnfiguration. With your kwoledge of AWS VPC services
you must configure :

- **1 VPC** with DHCP, DNS and Hostname resolution activated. Whatever CIDR is OK (example `192.168.0.0/24`)
- **1 internet gateway** with default configuration. Associated to the previously created VPC 
- **1 Subnet** routing all trafic from and to the internet gateway. All port opened and public IP activated.
- **1 DHCP configuration** with default configuration
- **1 Security group** with in and out traffic authorized for All traffic, TCP, ICMP and UDP inbound and outbound to/from anywhere

#### EC2 instance configuration

Start your single node server in order to install and configure your Openshift plateform.

- On EC2, click on **start a new instance**
- Choose Marketplace then type centos (hit enter) and choose **CentOS 7 (x86_64) - with Updates HVM**
- Select a **t2.xlarge** instance (t2.medium is minimum to run this application)
- On next screen, choose VPC and subnet previously created. Check `automated IP` is activated. and hit next
- Select a **50Go SSD** for storage, with **2500/IOP** on provisionned SSD, then next
- Create labels according to your labelling strategy
- Associate the **openAll security group** created in the previous section
- Choose your **ssh key** in your wallet or create a dedicated one
- Review and launch

#### Route53 DNS configuration

Enable you application to use your own domain zone and make application accessible to your domain.
In the next sections, we will assume you are responding to the DNS record `openshift.demo.startx.fr` for 
master node, and `*.openshift.demo.startx.fr` for applications.

- Copy the **public IP** associated to your starting instance, then go to route53 service
- Select a **domain zone** you want to use
- Create a **new DNS entry** of type `A`, with your selected master domain name (ex: `openshift.demo.startx.fr`) and the **public IP** adress as value. Hit "create"
- Create a **new DNS entry** of type `CNAME`, with your selected applications domain name (ex: `*.openshift.demo.startx.fr`) and the master domain name (ex: `openshift.demo.startx.fr`) as value. Hit "create"
- Wait for propagation

### Server installation

This section will help you install and run your openshift demo node on your EC2 instance previously launched.

- Connect to the server
```bash
# <ssh_key> your ssh key 
# <master_domain> your master domain name
# ex: ssh -i sx-eu-key-demo-openshift.pem centos@openshift.demo.startx.fr
ssh -i <ssh_key> centos@<master_domain>
```
- You must be root to install openshift and dependencies
```bash
sudo su -
yum install -y git
```
- Setup the DNS used for your demo environement
```bash
# <master_domain> your master domain name
# ex: export DNSNAME=openshift.demo.startx.fr
export DNSNAME=<master_domain>
```
- Run the following install script. Adapt the firsts parameters to your needs
```bash
cd ~
git clone https://github.com/startxfr/sxapi-demo-openshift.git
cd sxapi-demo-openshift
./openshift-install
```

- Start the openshift cluster
```bash
cd ~/sxapi-demo-openshift
./openshift-start
```

- Access your web-console using the `https://<master_domain>:8443` URL, where `<master_domain>` is your master domain name (ex: https://openshift.demo.startx.fr:8443).
- Access openshift cli using
```bash
oc login -u system:admin https://$DNSNAME:8443
```

## Setup Minishift environement

[Minishift](https://docs.openshift.org/latest/minishift/index.html) deliver simple and configured Openshift environement into various VM images.
You can then run a simple Openshift environement for developpement purpose.<br>
Read and follow the [minishift installation guide](https://docs.openshift.org/latest/minishift/getting-started/installing.html) if you want to run this demo into a minishift environement.

## After installation

Whatever your installation method and your Openshift environement, you must have access to it using oc-cli tools. 
If you don't have a local openshift client, you can follow [openshift CLI installation guide](https://docs.openshift.com/container-platform/3.9/cli_reference/get_started_cli.html#installing-the-cli).

You must login to your openshift cluser to start running this demo. After being successfully logged, you can [follow next steps of this demo](README.md)
```bash
# <user> your openshift username
# <pwd> your openshift password
# <master_domain> your master domain name
# ex: oc login -u system:admin https://openshift.demo.startx.fr:8443
oc login -u <user>:<pwd> https://<master_domain>
```

## Troubleshooting

If you run into difficulties installing or running this demo, you can [create an issue](https://github.com/startxfr/sxapi-demo-openshift/issues/new).

## Built With

* [amazon web-services](https://aws.amazon.com) - Infrastructure layer
* [docker](https://www.docker.com/) - Container runtime
* [kubernetes](https://kubernetes.io) - Container orchestrator
* [openshift](https://www.openshift.org) - Container plateform supervisor
* [nodejs](https://nodejs.org) - Application server
* [sxapi](https://github.com/startxfr/sxapi-core) - Microservice API framework

## Contributing

Read the [contributing guide](https://github.com/startxfr/sxapi-core/tree/testing/docs/guides/5.Contribute.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

This project is mainly developped by the [startx](https://www.startx.fr) dev team. You can see the complete list of contributors who participated in this project by reading [CONTRIBUTORS.md](https://github.com/startxfr/sxapi-core/tree/testing/docs/CONTRIBUTORS.md).

## License

This project is licensed under the GPL Version 3 - see the [LICENSE.md](https://github.com/startxfr/sxapi-core/tree/testing/docs/LICENSE.md) file for details
