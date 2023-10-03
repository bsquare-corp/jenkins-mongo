FROM mcr.microsoft.com/azure-cli:latest as build_mongo

ARG MONGO_VERSION=4.7.0

MAINTAINER Benjamin Tucker <benjamint@bsquare.com>

RUN apk add --no-cache --update curl alpine-sdk python3 xz-dev curl-dev

ADD . /mongo

RUN python3 -m pip install -r /mongo/etc/pip/compile-requirements.txt

WORKDIR /mongo
RUN python3 buildscripts/scons.py \
   MONGO_VERSION=${MONGO_VERSION} \
   CCFLAGS=-D__MUSL__ \
   DESTDIR=/usr \
   VERBOSE=off \
   install-shell --disable-warnings-as-errors --opt=size

# Strip binary
RUN strip -sg /usr/bin/mongo

# Remove all build artifacts
FROM scratch 

COPY --from=build_mongo /usr/bin/mongo /usr/bin/mongo
