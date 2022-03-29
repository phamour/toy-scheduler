#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "$GOPROXYCN" = "TRUE" ]] ;
then
    echo "Warning: using goproxy.cn"
    export GO111MODULE=on
    export GOPROXY=https://goproxy.cn
fi

go mod tidy
go mod vendor
