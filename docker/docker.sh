#!/usr/bin/env bash

upOption=""
login=false
force=false
optspec=":ld"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        l)
             echo "->Login after start up" >&2
             login=true
             upOption="-d"
            ;;
        d)
             echo "->Start up to background" >&2
             upOption="-d"
            ;;
        f)
              echo "->Force start up" >&2
              force=true
              upOption="-d"
              ;;
    esac
done


prepareFiles () {
    FILES=("./data/.bash_history")
    FOLDERS=("~/.docker/composer", "~/.docker/cache", "~/.docker/config", "~/.docker/local", "data")
    NGINX="./nginx"

    if [ ! -e ./.env ]; then
        cp ./.env.dist ./.env
    fi

    for folder in $FOLDERS; do
        mkdir -p $folder
    done

    for file in $FILES; do
        touch $file
    done

    uid=$(id -u)
    if [ $uid -gt 100000 ]; then
        uid=1000
    fi

    case "$(uname -s)" in
        Linux*) host_ip="172.17.0.1";;
        Darwin*)
          if ! hash docker-sync 2>/dev/null; then
            host_ip=$(dlite status | grep dns_server | grep -oE "[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}")
          else
            host_ip="host.docker.internal"
          fi
        ;;
    esac

    if ! hash docker-sync 2>/dev/null; then
        sed "s/\$USER_ID/$uid/g" ./php7.1-fpm/Dockerfile.dist > ./php7.1-fpm/Dockerfile
        sed "s/\$USER_ID/$uid/g" ./php7.2-fpm/Dockerfile.dist > ./php7.2-fpm/Dockerfile
        sed "s/\$USER_ID/$uid/g" ./nginx/Dockerfile.dist > ./nginx/Dockerfile
    else
        sed "s/\$USER_ID/33/g" ./php7.1-fpm/Dockerfile.dist > ./php7.1-fpm/Dockerfile
        sed "s/\$USER_ID/33/g" ./php7.2-fpm/Dockerfile.dist > ./php7.2-fpm/Dockerfile
        sed "s/\$USER_ID/33/g" ./nginx/Dockerfile.dist > ./nginx/Dockerfile
    fi

    sed -i "s/\$HOST_IP/$host_ip/g" ./php7.1-fpm/Dockerfile
    sed -i "s/\$HOST_IP/$host_ip/g" ./php7.2-fpm/Dockerfile
    sed "s/\$HOST_IP/$host_ip/g" ./.env.dist> ./.env
    source ./.env

    sed "s/\$PROJECT/$PROJECT/g" ./docker-compose.yml.dist > ./docker-compose.yml
    sed "s/\$PROJECT/$PROJECT/g" ./docker-compose-dev.yml.dist > ./docker-compose-dev.yml
    sed "s/\$PROJECT/$PROJECT/g" ./docker-sync.yml.dist > ./docker-sync.yml

    if [ -f "$NGINX/default.conf.dist" ]; then
        sed "s/\$PROJECT/$PROJECT/g" ./nginx/default.conf.dist > ./nginx/default.conf
    fi

    if [ -f "$NGINX/symfony4.conf.dist" ]; then
        sed "s/\$PROJECT/$PROJECT/g" ./nginx/symfony4.conf.dist > ./nginx/default.conf
    fi

    if [ -f "$NGINX/silverstripe4.conf.dist" ]; then
        sed "s/\$PROJECT/$PROJECT/g" ./nginx/silverstripe4.conf.dist > ./nginx/default.conf
    fi

    if [ -f "$NGINX/silverstripe3.conf.dist" ]; then
        sed "s/\$PROJECT/$PROJECT/g" ./nginx/silverstripe3.conf.dist > ./nginx/default.conf
    fi

    sed "s/\$PHP/$PHP/g" ./docker-compose-dev.yml.dist > ./docker-compose-dev.yml
    sed "s/\$PHP/$PHP/g" ./docker-compose.yml.dist > ./docker-compose.yml
    sleep 2

}


prepareFiles

source ./.env

##force stop and destroy containers
if [ $force = true ]; then
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
fi

##build and launch containers
docker-compose build
if ! hash docker-sync 2>/dev/null; then
    docker-compose up $upOption
else
    docker-sync start
    docker-compose -f docker-compose.yml -f docker-compose-dev.yml up $upOption
fi

containerName="${PROJECT}_php"

##add ssh folder to enable access to private repos
docker cp --follow-link ~/.ssh $containerName:/var/www/

##make ssh files accessable for www-data
docker exec -it $containerName chown -R www-data:www-data /var/www/.ssh
docker exec -it $containerName chown -R www-data:www-data /var/www/.host
docker exec -it $containerName chown -R www-data:www-data /var/www/.docker

##composer selfupdate
docker exec -it $containerName composer selfupdate

if [ $login = true ]; then
	docker exec -it -u www-data $containerName bash
	if hash docker-sync 2>/dev/null; then
	    docker-sync-stack clean
	else
	    docker-compose stop
	    docker-compose down
	fi
fi
