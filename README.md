# sxapi-demo-openshift

Demo application to show how to build and deploy a 3-tiers application using 
[startx/sv-nodejs s2i builder](https://hub.docker.com/r/startx/sv-nodejs) (source-to-image) to build 2 applications 
based on [sxapi micro-service framework](https://github.com/startxfr/sxapi-core/) 
on top of an [openshift platform](https://www.openshift.org).

This demo intend to show how you can run an full application using [Openshift PAAS](https://www.openshift.org)
or [Red Hat Openshift](https://www.redhat.com/fr/technologies/cloud-computing/openshift) as
building and running plateform. By using [docker](https://hub.docker.com/r/startx), managed by 
[Kubernetes](https://kubernetes.io) and superset with CI/CD + security and management feature bringed by
[Openshift](https://www.openshift.org) layer, you will see how to use the latest technologies 
to run scalable, resilient and secured application on top of a smart and distributed architecture.<br>
You will also discovert a [simple API framework](https://github.com/startxfr/sxapi-core/) useful for creating 
simple and extensible API using a micro-service architecture. [SXAPI project](https://github.com/startxfr/sxapi-core/)
is based on [nodejs](https://nodejs.org) technologie and is 
available as a docker image on dockerhub ([sxapi image](https://hub.docker.com/r/startx/sxapi)) or as an
npm module ([sxapi npm module](https://www.npmjs.com/package/sxapi-core))

```
 .---------------.          .---------------.   .---------------.                 .-,(  ),-.    
 |      db       |          |      API      |   |   frontend    |              .-(          )-. 
 |---------------|<---------|---------------|   |---------------|------------>(    internet    )
 | mariadb       |          | nodejs / json |   | nodejs / html |              '-(          ).-'
 '---------------'          '---------------'   '---------------'                  '-.( ).-'    
                                    ^                                                  |
                                    '--------------------------------------------------'
```

## Setup workstation environement

Running the complete agenda of this demo require your local or demo workstation to meet the following requirements :
- `git` command must be installed
- internet access must be configured
- `docker` command must be installed and running (for docker and s2i deployement strategy).
  You must have access to the running `docker` daemon with access to the dockerhub public registry.
  If you don't have docker runtime, please follow [docker](https://docs.docker.com/)
  installation guide for [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/), 
  [RHEL](https://docs.docker.com/install/linux/docker-ee/rhel/), 
  [Windows](https://docs.docker.com/docker-for-windows/install/)
  or [MacOS](https://docs.docker.com/docker-for-mac/install/).
- `s2i` command must be installed (for s2i deployement strategy)
- `oc` command must be installed (for openshift deployement strategies)

All openshift template is self sufficient and we can use all of them without having a local copy of the source code.
However, for all docker build and s2i build strategy, whe need to have a local copy of source code. In order to run the 
complete demo agenda, you need to install a local copy of the source code.

```bash
cd ~
git clone https://github.com/startxfr/sxapi-demo-openshift.git
cd sxapi-demo-openshift
```

## Setup Openshift environement

### Create Openshift cluster

You will find in our [Openshift installation guide](INSTALL.md) instructions for creating an Openshift cluster
using [Openshift Online](INSTALL.md#setup-openshift-online-environement), 
[Openshift Origin on AWS](INSTALL.md#setup-openshift-online-environement-AWS--environement-) as well as 
[Minishift](INSTALL.md#setup-minishift-environement) configurations.

### Create Openshift project

#### Create Openshift project using web-console

In openshift Origin, if you want to visualize your objects in the web-console, you should create the project 
from the Web console. 

- Connect to the web console using `https://openshift.demo.startx.fr:8443`
- Authenticate using the system admin user `system` with passsword `admin`
- Create a new project (right panel) and name it. We will assume your project name for this demo will be `demo`

#### Create Openshift project using oc-cli

```bash
# <user> your openshift username
# <pwd> your openshift password
# <master_domain> your master domain name
# <project> your project name
# ex: oc login -u system:admin https://openshift.demo.startx.fr:8443
# ex: oc new-project demo; oc project demo
oc login -u <user>:<pwd> https://<master_domain>
oc new-project <project>
oc project <project>
```

## Deploy demo application

This section will help you start a build and deploy of this demo application stack using various build and
deployement strategies.


### Deploy demo application using docker

### Build images using Dockerfile

```bash
pwd
# $ ~/sxapi-demo-openshift
# build api frontend container
docker build -t sxapi-demo-api api
# build web frontend container
docker build -t sxapi-demo-www www
```

### Deploy database service using docker

```bash
# deploy database backend container
docker run -d \
       --name sxapi-demo-openshift-db \
       -e SX_VERBOSE=true \
       -e SX_DEBUG=true \
       -e MYSQL_USER="dev-user" \
       -e MYSQL_PASSWORD="dev-pwd123" \
       -e MYSQL_DATABASE="demo" \
       -v ./db:/tmp/sql:z \
       -p 3306:3306 \
       startx/sv-mariadb:latest \
       /bin/sx-mariadb run
sleep 20
docker logs sxapi-demo-openshift-db
```

### Deploy API service using docker

```bash
# deploy api frontend container
docker run -d \
       --name sxapi-demo-openshift-api \
       -e SX_VERBOSE=true \
       -e SX_DEBUG=true \
       -e MARIADB_SERVICE_HOST="sxapi-demo-openshift-db" \
       -e MYSQL_USER="dev-user" \
       -e MYSQL_PASSWORD="dev-pwd123" \
       -e MYSQL_DATABASE="demo" \
       --link sxapi-demo-openshift-db:db \
       -p 8080:8080 \
       sxapi-demo-api \
       /bin/sx-nodejs run
sleep 1
docker logs sxapi-demo-openshift-api
```

### Deploy WWW service using docker

```bash
# deploy www frontend container
docker run -d \
       --name sxapi-demo-openshift-www \
       -e SX_VERBOSE=true \
       -e SX_DEBUG=true \
       -p 8081:8080 \
       sxapi-demo-www \
       /bin/sx-nodejs run
sleep 1
docker logs sxapi-demo-openshift-www
```

### Docker strategy workflow

```
.--------------------------.
| source code (sxapi-demo) |
|--------------------------|-.
| local copy ./www/        | |        .----------------.        .----------------.
'--------------------------' | docker |   WWW image    | docker | WWW container  |8080
                             .------->|----------------|------->|----------------|--.
.--------------------------. | build  | sxapi-demo-www | run    | sxapi-demo-www |  |      .-,(  ),-.    
|     base image (s2i)     | |        '----------------'        '----------------'  |   .-(          )-. 
|--------------------------|-'                                                      .->(    internet    )
| startx/sv-nodejs         |-.                                                      |   '-(          ).-'
'--------------------------' |        .----------------.        .----------------.  |       '-.( ).-'    
                             | docker |   API image    | docker | API container  |--'
.--------------------------. .------->|----------------|------->|----------------|8081
| source code (sxapi-demo) | | build  | sxapi-demo-api | run    | sxapi-demo-api |
|--------------------------|-'        '----------------'        '----------------'
| local copy ./api/        |                                             |
'--------------------------'                                             |
                                                                         v 3306
.--------------------------.                                    .----------------.
|     base image (s2i)     |                             docker |  DB container  |
|--------------------------|----------------------------------->|----------------|
| startx/sv-mariadb        |                             run    | sxapi-demo-db  |
'--------------------------'                                    '----------------'
```







### Create application in openshift

```bash
oc process -f openshift-build-all-ephemeral.json -p DEMO_API=openshift.demo.startx.fr | oc create -f -
echo "wait 60sec"
sleep 60
oc get all
```

### Access your application in your browser

Access your application using your browser on `https://api.openshift.demo.startx.fr`


## Troubleshooting

If you run into difficulties installing or running sxapi, you can [create an issue](https://github.com/startxfr/sxapi-core/issues/new).

## Built With

* [amazon web-services](https://aws.amazon.com) - Infrastructure layer
* [docker](https://www.docker.com/) - Container runtime
* [kubernetes](https://kubernetes.io) - Container orchestrator
* [openshift](https://www.openshift.org) - Container plateform supervisor
* [nodejs](https://nodejs.org) - Application server
* [sxapi](https://github.com/startxfr/sxapi-core) - API framework

## Contributing

Read the [contributing guide](https://github.com/startxfr/sxapi-core/tree/testing/docs/guides/5.Contribute.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

This project is mainly developped by the [startx](https://www.startx.fr) dev team. You can see the complete list of contributors who participated in this project by reading [CONTRIBUTORS.md](https://github.com/startxfr/sxapi-core/tree/testing/docs/CONTRIBUTORS.md).

## License

This project is licensed under the GPL Version 3 - see the [LICENSE.md](https://github.com/startxfr/sxapi-core/tree/testing/docs/LICENSE.md) file for details
