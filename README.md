# sxapi-demo-openshift

Example application of a 3-tiers application using [sxapi](https://github.com/startxfr/sxapi-core/) 
on top of an [openshift platform](https://www.openshift.org).

This demo intend to show how you can run an full application using [Openshift PAAS](https://www.openshift.org)
or [Red Hat Openshift](https://www.redhat.com/fr/technologies/cloud-computing/openshift) as
building and running plateform. Using [docker](https://hub.docker.com/r/startx), managed by 
[Kubernetes](https://kubernetes.io) and superset with CI/CD + security and management feature bringed by
[Openshift](https://www.openshift.org) layer, you will see how to use the latest technologies 
to run scalable, resilient and secured application on top of a smart and distributed architecture.<br>
You will also discovert a [simple API framework](https://github.com/startxfr/sxapi-core/) useful for creating 
simple and extensible API using a micro-service architecture. [SXAPI project](https://github.com/startxfr/sxapi-core/)
is based on [nodejs](https://nodejs.org) technologie and is 
available as a docker image on dockerhub ([sxapi image](https://hub.docker.com/r/startx/sxapi)) or as an
npm module ([sxapi npm module](https://www.npmjs.com/package/sxapi-core))

## Setup demo environement

You will find in our [Openshift installation guide](INSTALL.md) instructions for creating an Openshift cluster
using [Openshift Online](INSTALL.md#setup-openshift-online-environement), 
[Openshift Origin on AWS](INSTALL.md#setup-openshift-online-environement-AWS--environement-) or using
[Minishift](INSTALL.md#setup-minishift-environement)

## Deploy your application

This section will help you start a build and deploy of your application stack.

### Create project in openshift

In order to visualize your objects in the webconsole, you should create the project 
using the Web console. 

- Connect to the web console using `https://openshift.demo.startx.fr:8443`
- Authenticate using the system admin user `system` with passsword `admin`
- Create a new project (right panel) and name it. We will assume your project name for this demo will be `demo`

### Create project in openshift

```
oc login -u system:admin
oc new-project demo
oc project demo
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
