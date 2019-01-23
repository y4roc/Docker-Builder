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
6. Run `composer` for to install your favourite framework & libraries

## Open new Terminal

You can access the project-terminal with the script `/docker/docker-ssh.sh [username]`. The argument username is optional and can be used, to grant root rights. In default you will logged in with user `www-data`.  

## Debugging

### For PhpStorm

1. Open `Run/Debug Configuration` and add `PHP Remote Debug`.
2. Choose a name for your configuration.
3. Activate checkbox `Filter debug connection by IDE key`.
4. Set `IDE key` to `PHPSTORM`.
5. Open server-settings with click of the button `…`.
6. Add a new server.configuration.
7. Named the server `docker-localhost`.
8. Set the host to `localhost` or the domain you choosed for your local docker-project.
9. Set the port to 8080 and activate `Use path mappings`.
10. Map the directory `www` to `/var/www/html/www` and save your configuration.

Now you can use PhpStorm for debugging http-requests and cli-php-scripts on your docker-maschine.
