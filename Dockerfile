# Version. Can change in build progress
ARG GCLOUD_SDK_VERSION=302.0.0-alpine

# Use google cloud sdk
FROM google/cloud-sdk:$GCLOUD_SDK_VERSION
MAINTAINER clementoh

# Install Java 8 for Datastore emulator
RUN apk add --update --no-cache openjdk11-jre &&\
    gcloud components install cloud-datastore-emulator beta --quiet

ENV DATASTORE_PROJECT_ID=project-test
ENV DATASTORE_LISTEN_ADDRESS=0.0.0.0:8081

# Volume to persist Datastore data
VOLUME /opt/data

COPY start-datastore.sh .

EXPOSE 8081

ENTRYPOINT ["./start-datastore.sh"]
