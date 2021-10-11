#!/usr/bin/env bash
VERSION=v10.7-1

mkdir realtek

curl -L https://github.com/jjm2473/rtd1296_prebuilt_target/releases/download/v1.0/jellyfin-rtk-docker_10-7.tar | tar -x -C realtek || exit 1

docker build -t jjm2473/jellyfin-server-rtk:$VERSION -f deployment/Dockerfile.docker.arm64 . || exit 1

docker build -t jjm2473/jellyfin-rtk:$VERSION -f Dockerfile.rtk . || exit 1
