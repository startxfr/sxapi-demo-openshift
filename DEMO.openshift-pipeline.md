# Deploy demo application using Openshift pipeline

This section of the [sxapi-demo-openshift](https://github.com/startxfr/sxapi-demo-openshift)
will show you how to run the sxapi-demo application stack using openshift Openshift pipeline
strategy. Jenkins will be used as a CI/CD backend for your deployement process.

To run this demo, you must have have a demo environement setup configured. Follow guidelines 
to configure the [workstation environement](https://github.com/startxfr/sxapi-demo-openshift#setup-workstation-environement)
and [openshift environement](https://github.com/startxfr/sxapi-demo-openshift#setup-openshift-environement).

## Openshift template

This demo provide an [all-in-one pipeline template](https://raw.githubusercontent.com/startxfr/sxapi-demo-openshift/dev/openshift-pipeline-all-ephemeral.json)
to build and deploy test and run stagging environement each containing the full application stack.

This template will create the following objects :
- **1 BuildConfig** describing the Jenkins pipeline workflow and CI/CD orchestration
- **1 ImageStream** with 2 tags linked to public bases images `startx/sv-mariadb` and `startx/sv-nodejs`
- **3 ImageStream** with `latest`, `test` and `prod` tag each and used for hosting the **mariadb**, **api** and **www** build image coresponding to both stages
- **2 Secret** `mariadb-test` and `mariadb-prod` holding `MYSQL_ROOT_PASSWORD`, `MYSQL_USER` and `MYSQL_PASSWORD` credentials
- **6 BuildConfig** describing how to build the **mariadb**, **api** and **www** images for both `test` and `prod` stage
- **6 DeploymentConfig** describing how to deploy and run the **mariadb**, **api** and **www** components for both `test` and `prod` stage
- **2 Service** to expose **mariadb** to other pods (created by the deploymentConfig) for both `test` and `prod` stage
- **4 Service** to expose **api** and **www** internaly and linked to route objects for both `test` and `prod` stage
- **4 Route** to expose **api** and **www** externaly for both `test` and `prod` stage

You can create and use this template running the following command. You can only run it one time per project. 
This template create both stage resources into the same project (shared namespace) for demo simplification. In production,
we would prefer create one project per stage in order to isolate environments and flexibility in managing hardware resources, 
users, network and node allocation.

```bash
oc new-project demo
oc process -f https://raw.githubusercontent.com/startxfr/sxapi-demo-openshift/dev/openshift-pipeline-all-ephemeral.json \
           -v DEMO_API=demo.apps.startx.fr \
           -v MYSQL_USER="demouser" \
           -v MYSQL_PASSWORD="demopwd123" \
           -v MYSQL_DATABASE="demo" | \
oc create -f -
sleep 5
oc get all
```

## Openshift build and deploy strategy workflow

```
                                                               .----------.
                                                               |   Pod    |
                                                             .>|----------|<.
          .--------------------------.   .-----------------. | | demo-api | | .----------.
          |       Source code        |   |  DeployConfig   | | '----------' | | Service  |
          |--------------------------|   |-----------------|-. .----------. .------------|
          | sxapi-demo-openshift/www |   | demo-www        | | |   Pod    | | | demo-www |
          '--------------------------'   '-----------------' '>|----------|<' '----------'
                              |                   ^            | demo-api |      /
                              v                   |            '----------'     /
                       .-------------.   .-----------------.        .----------v
                       | BuildConfig |   |    API image    |        |  Route   |
                       |-------------|-->|-----------------|        |----------|
                       | demo-www    |   | demo-www:latest |        | demo-www |
                       ^-------------'   '-----------------'        '----------\
   .------------------/                                                         v .-,(  ),-.    
   |  Builder image   |                                                        .-(          )-. 
   |------------------|                                                       (    internet    )
   | startx/sv-nodejs |                                                        '-(          ).-'
   '------------------\                                                         ^  '-.( ).-'    
                       v-------------.   .-----------------.        .----------/
                       | BuildConfig |   |    API image    |        |  Route   |
                       |-------------|-->|-----------------|        |----------|
                       | demo-api    |   | demo-api:latest |        | demo-api |
                       '-------------'   '-----------------'        '----------^
                              ^                   |                             \
                              |                   |            .----------.      \
                              |                   |            |   Pod    |       \
                              |                   v          .>|----------|<.  .----------.
          .--------------------------.   .-----------------. | | demo-api | |  | Service  |
          |       Source code        |   |  DeployConfig   | | '----------' .--|----------|
          |--------------------------|   |-----------------|-. .----------. |  | demo-api |
          | sxapi-demo-openshift/api |   | demo-api        | | |   Pod    | |  '----------'
          '--------------------------'   '-----------------' '>|----------|<'
                                                               | demo-api |
                                                               '----------'
                                                                     ^
                                                                     |
.-------------------.  .-------------.   .-----------------.   .----------.
|   Builder image   |  | BuildConfig |   |    API image    |   | Service  |
|-------------------|->|-------------|-->|-----------------|   |----------|
| startx/sv-mariadb |  | demo-api    |   | demo-api:latest |   | demo-api |
'-------------------'  '-------------'   '-----------------'   '----------'
                              ^                   |                  |
                              |                   v                  v
          .--------------------------.   .-----------------.   .----------.
          |       Source code        |   |  DeployConfig   |   |   Pod    |
          |--------------------------|   |-----------------|-->|----------|
          | sxapi-demo-openshift/api |   | demo-api        |   | demo-api |
          '--------------------------'   '-----------------'   '----------'
```

### Access your application in your browser

Access your application using your browser on `https://api.openshift.demo.startx.fr`


## Troubleshooting, contribute & credits

If you run into difficulties installing or running this demo [create an issue](https://github.com/startxfr/sxapi-demo-openshift/issues/new).

You will information on [how to contribute](https://github.com/startxfr/sxapi-demo-openshift#contributing) or 
[technologies credits](https://github.com/startxfr/sxapi-demo-openshift#built-with) and
[demo authors](https://github.com/startxfr/sxapi-demo-openshift#authors) on the 
[sxapi-demo-openshift homepage](https://github.com/startxfr/sxapi-demo-openshift).