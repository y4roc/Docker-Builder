# Docker Builder

This docker configuration is designed for webapps based on PHP. It's includes composer to manage PHP-Libraries, node.js with yarn to manage JS-Libraries for frontend and deployer.php to deploy your porject on your server.

## Required

Following programs are required to use Docker Builder.

- [docker-ce](https://docs.docker.com/install/)
- [docker-compose](https://docs.docker.com/compose/install/)

_Optional:_

- [docker-sync](http://docker-sync.io/) (for OS X only. It speed the transfer of files between host and vm up)

## Installation for new projects

1. Clone this project and remove `.git` or download the archive and unpack it.
2. Update or project shortcut at `/docker/.env.dist` (`PROJECT=np`).
3. Choose your favorite PHP-Version in row three at the same file.
4. Remove unused nginx-configs (`*.dist`) from `/docker/nginx/`.
5. To start this docker-container go in the folder `docker` and run `./docker.sh -l`. The Argument `-l` logged you in this container.

## Open new Terminal

You can access the project-terminal with the script `/docker/docker-ssh.sh [username]`. The argument username is optional and can be used, to grant root rights. In default you will logged in with user `www-data`.  
