# Deploy demo application using docker only

This section of the [sxapi-demo-openshift](https://github.com/startxfr/sxapi-demo-openshift)
will show you how to run the sxapi-demo application stack only using docker command.

To run this demo, you must have have a demo environement setup configured. Follow guidelines 
to configure the [workstation environement](https://github.com/startxfr/sxapi-demo-openshift#setup-workstation-environement).

## Build images using Dockerfile

```bash
pwd
# $ ~/sxapi-demo-openshift
# build api frontend container
docker build -t sxapi-demo-api api
# build web frontend container
docker build -t sxapi-demo-www www
```

## Deploy database service using docker

```bash
# deploy database backend container
docker run -d \
       --name sxapi-demo-openshift-db \
       -e SX_VERBOSE=true \
       -e SX_DEBUG=true \
       -e MYSQL_USER="master-user" \
       -e MYSQL_PASSWORD="master-pwd123" \
       -e MYSQL_DATABASE="demo" \
       -v ./db:/tmp/sql:z \
       -p 3306:3306 \
       startx/sv-mariadb:latest \
       /bin/sx-mariadb run
sleep 20
docker logs sxapi-demo-openshift-db
```

## Deploy API service using docker

```bash
# deploy api frontend container
docker run -d \
       --name sxapi-demo-openshift-api \
       -e SX_VERBOSE=true \
       -e SX_DEBUG=true \
       -e MARIADB_SERVICE_HOST="sxapi-demo-openshift-db" \
       -e MYSQL_USER="master-user" \
       -e MYSQL_PASSWORD="master-pwd123" \
       -e MYSQL_DATABASE="demo" \
       --link sxapi-demo-openshift-db:db \
       -p 8080:8080 \
       sxapi-demo-api \
       /bin/sx-nodejs run
sleep 1
docker logs sxapi-demo-openshift-api
```

## Deploy WWW service using docker

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

## Docker strategy workflow

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

### Access your application in your browser

Access your application using your browser on `http://localhost:8080`


## Troubleshooting, contribute & credits

If you run into difficulties installing or running this demo [create an issue](https://github.com/startxfr/sxapi-demo-openshift/issues/new).

You will information on [how to contribute](https://github.com/startxfr/sxapi-demo-openshift#contributing) or 
[technologies credits](https://github.com/startxfr/sxapi-demo-openshift#built-with) and
[demo authors](https://github.com/startxfr/sxapi-demo-openshift#authors) on the 
[sxapi-demo-openshift homepage](https://github.com/startxfr/sxapi-demo-openshift).
