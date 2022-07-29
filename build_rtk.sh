#!/usr/bin/env bash
VERSION=4.9-v10.8

# [ -f realtek/Dockerfile ] || ( mkdir realtek && curl -L https://github.com/jjm2473/rtd1296_prebuilt_target/releases/download/v1.0/jellyfin-rtk-docker_10-7_4-9.tar | tar -x -C realtek ) || exit 1

# docker build -t jjm2473/jellyfin-server-rtk:$VERSION -f deployment/Dockerfile.docker.arm64 . || exit 1

# [ -d realtek/jellyfin-web ] || cp -a /Volumes/data/src/jellyfin-web/dist realtek/jellyfin-web
# docker build --cache-from jjm2473/jellyfin-rtk:$VERSION -t jjm2473/jellyfin-rtk-cache:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.rtk-cache realtek || exit 1
# docker tag jjm2473/jellyfin-rtk-cache:$VERSION localhost:5000/jjm2473/jellyfin-rtk-cache:$VERSION
# docker push localhost:5000/jjm2473/jellyfin-rtk-cache:$VERSION

docker build --pull -t jjm2473/jellyfin-rtk:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.rtk realtek || exit 1

