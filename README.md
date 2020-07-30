# Google Cloud Datastore Emulator

[Original repository](https://github.com/SingularitiesCR/datastore-emulator-docker) was awesome and
provided all the hard setup work. However, it was no longer maintained and the
Google Cloud datastore component fell behind by over 100 versions. Most of this repository is
the same except the version of the datstore emulator. Thanks
[@SingularitiesCR](https://github.com/SingularitiesCR) for putting in the ground work.

A [Google Cloud Datastore Emulator](https://cloud.google.com/datastore/docs/tools/datastore-emulator/) container image. The image is meant to be used for creating an standalone emulator for testing.

## Environment

The following environment variables must be set:

- `DATASTORE_LISTEN_ADDRESS`: The address should refer to a listen address, meaning that `0.0.0.0` can be used. The address must use the syntax `HOST:PORT`, for example `0.0.0.0:8081`. The container must expose the port used by the Datastore emulator.
- `DATASTORE_PROJECT_ID`: The ID of the Google Cloud project for the emulator.

## Connect application with the emulator

The following environment variables need to be set so your application connects to the emulator instead of the production Cloud Datastore environment:

- `DATASTORE_EMULATOR_HOST`: The listen address used by the emulator.
- `DATASTORE_PROJECT_ID`: The ID of the Google Cloud project used by the emulator.

## Custom commands

This image contains a script named `start-datastore` (included in the PATH). This script is used to initialize the Datastore emulator.

### Starting an emulator

By default, the following command is called:

```sh
start-datastore
```
### Starting an emulator with options

This image comes with the following options: `--no-store-on-disk` and `--consistency`. Check [Datastore Emulator Start](https://cloud.google.com/sdk/gcloud/reference/beta/emulators/datastore/start). `--legacy`, `--data-dir` and `--host-port` are not supported by this image.

```sh
start-datastore --no-store-on-disk --consistency=1.0
```

## Creating a Datastore emulator with Docker Compose

The easiest way to create an emulator with this image is by using [Docker Compose](https://docs.docker.com/compose). The following snippet can be used as a `docker-compose.yml` for a datastore emulator:

```YAML
version: '3'

services:
  datastore:
    build:
      context: .
      dockerfile: Dockerfile.datastore-emulator
    ports:
      - '8081:8081'
  test:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      - datastore
    environment:
      # setting these environment variables will force google cloud
      # datastore library to connect to local datastore emulator
      - DATASTORE_PROJECT_ID=project-test
      - DATASTORE_EMULATOR_HOST=datastore:8081
```

### Persistence

The image has a volume mounted at `/opt/data`. To maintain states between restarts, mount a volume at this location.
