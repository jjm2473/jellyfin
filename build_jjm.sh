#!/usr/bin/env bash
VERSION=v10.8.10
STAGE=${1:-0}

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

if [[ $STAGE -le 0 ]]; then
    # debian with jellyfin-ffmpeg and fonts
    docker build -t jjm2473/jellyfin-runtime:v1 -f Dockerfile.runtime deployment || exit 1
    docker push jjm2473/jellyfin-runtime:v1
fi

if [[ $STAGE -le 1 ]]; then
    # build this jellyfin server
    docker build -t jjm2473/jellyfin-server-build:$VERSION -f deployment/Dockerfile.docker.arm64 . || exit 1
    docker build -t jjm2473/jellyfin-server:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.server deployment || exit 1
    docker push jjm2473/jellyfin-server:$VERSION
fi

if [[ $STAGE -le 3 ]]; then
    if [[ $STAGE -le 2 || ! -f common/jellyfin-web/index.html ]]; then
        # copy jellyfin web
        rm -rf common/jellyfin-web
        mkdir common
        cp -a /Volumes/data/src/jellyfin-web/dist common/jellyfin-web
    fi

    [[ -f common/jellyfin-web/index.html ]] || { echo "common/jellyfin-web/index.html not exists">&2 ; exit 1; }
    # create common image
    docker build -t jjm2473/jellyfin-base:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.base common || exit 1
    ## push local repo, ignore error
    # docker tag jjm2473/jellyfin-base:$VERSION localhost:5000/jjm2473/jellyfin-base:$VERSION
    # docker push localhost:5000/jjm2473/jellyfin-base:$VERSION 2>/dev/null

    docker push jjm2473/jellyfin-base:$VERSION
fi

if [[ $STAGE -le 4 ]]; then
    # build rtd1296 image
    [ -f realtek/Dockerfile.sample ] || ( mkdir realtek && curl -L https://github.com/jjm2473/rtd1296_prebuilt_target/releases/download/v1.0/jellyfin-rtk-ffmpeg_4.0.3.tar | tar -x -C realtek ) || exit 1

    docker build --pull -t jjm2473/jellyfin-rtk:4.9-$VERSION --build-arg VERSION=$VERSION -f Dockerfile.rtk realtek || exit 1

    # build rockchip image
    [ -f rockchip/Dockerfile.sample ] || ( mkdir rockchip && curl -L https://github.com/jjm2473/ffmpeg-rk/releases/download/v1.0/jellyfin-rkmpp-ffmpeg_5.1-2.git.tar | tar -x -C rockchip ) || exit 1

    docker build --pull -t jjm2473/jellyfin-mpp:$VERSION --build-arg VERSION=$VERSION -f Dockerfile.rk rockchip || exit 1
fi

if [[ $STAGE = 5 ]]; then
    docker push jjm2473/jellyfin-rtk:4.9-$VERSION || exit 1
    docker push jjm2473/jellyfin-mpp:$VERSION || exit 1
fi

if [[ $STAGE = 6 ]]; then
    DATE=`date '+%Y%m%d%H'`
    docker tag jjm2473/jellyfin-rtk:4.9-$VERSION jjm2473/jellyfin-rtk:4.9-latest
    docker tag jjm2473/jellyfin-mpp:$VERSION jjm2473/jellyfin-mpp:latest
    docker push jjm2473/jellyfin-rtk:4.9-latest || exit 1
    docker push jjm2473/jellyfin-mpp:latest || exit 1
    docker tag jjm2473/jellyfin-rtk:4.9-$VERSION jjm2473/jellyfin-rtk:4.9-$DATE
    docker tag jjm2473/jellyfin-mpp:$VERSION jjm2473/jellyfin-mpp:$DATE
    docker push jjm2473/jellyfin-rtk:4.9-$DATE
    docker push jjm2473/jellyfin-mpp:$DATE
fi

# push test
if [[ $STAGE = 7 ]]; then
    docker tag jjm2473/jellyfin-rtk:4.9-$VERSION jjm2473/jellyfin-rtk:4.9-$VERSION-test
    docker tag jjm2473/jellyfin-mpp:$VERSION jjm2473/jellyfin-mpp:$VERSION-test
    docker push jjm2473/jellyfin-rtk:4.9-$VERSION-test || exit 1
    echo "pushed jjm2473/jellyfin-rtk:4.9-$VERSION-test"
    docker push jjm2473/jellyfin-mpp:$VERSION-test || exit 1
    echo "pushed jjm2473/jellyfin-mpp:$VERSION-test"
fi
