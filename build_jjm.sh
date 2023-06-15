#!/usr/bin/env bash
VERSION=v10.8

## build this jellyfin server
# docker build -t jjm2473/jellyfin-server:$VERSION -f deployment/Dockerfile.docker.arm64 . || exit 1

## copy jellyfin web
# rm -rf common/jellyfin-web
# mkdir common
# cp -a /Volumes/data/src/jellyfin-web/dist common/jellyfin-web

## create common image
# docker build -t jjm2473/jellyfin-base:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.base common || exit 1
# docker tag jjm2473/jellyfin-base:$VERSION localhost:5000/jjm2473/jellyfin-base:$VERSION
## push local repo, ignore error
# docker push localhost:5000/jjm2473/jellyfin-base:$VERSION 2>/dev/null

# build rtd1296 image
[ -f realtek/Dockerfile.sample ] || ( mkdir realtek && curl -L https://github.com/jjm2473/rtd1296_prebuilt_target/releases/download/v1.0/jellyfin-rtk-ffmpeg_4.0.3.tar | tar -x -C realtek ) || exit 1

docker build --pull -t jjm2473/jellyfin-rtk:4.9-$VERSION --build-arg VERSION=$VERSION -f Dockerfile.rtk realtek || exit 1

# build rockchip image
[ -f rockchip/Dockerfile.sample ] || ( mkdir rockchip && curl -L https://github.com/jjm2473/ffmpeg-rk/releases/download/v1.0/jellyfin-rkmpp-ffmpeg_5.1-2.git.tar | tar -x -C rockchip ) || exit 1

docker build --pull -t jjm2473/jellyfin-mpp:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.rk rockchip || exit 1
