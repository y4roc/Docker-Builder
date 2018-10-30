#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/.env"

USER=www-data

if [ ! -z $1 ]; then
    USER=$1
fi

docker exec -it -u $USER "${PROJECT}_php" bash