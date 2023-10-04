FROM mcr.microsoft.com/azure-cli:latest as build_mongo


MAINTAINER Benjamin Tucker <benjamint@bsquare.com>

RUN apk add --no-cache --update curl alpine-sdk python3 xz-dev curl-dev

ADD . /mongo

WORKDIR /mongo

RUN python3 -m pip install 'poetry==1.5.1'
RUN python3 -m poetry install --no-root --sync

RUN python3 buildscripts/scons.py \
   CCFLAGS=-D__MUSL__ \
   DESTDIR=/usr \
   VERBOSE=off \
   install-devcore --disable-warnings-as-errors --opt=size

# Strip binary
RUN strip -sg /usr/bin/mongo

# Remove all build artifacts
FROM scratch 

COPY --from=build_mongo /usr/bin/mongo /usr/bin/mongo
