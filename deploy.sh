#!/bin/bash

docker ps
docker container ls
sudo docker login --username $HEROKU_DOCKER_USERNAME --password $HEROKU_AUTH_TOKEN registry.heroku.com
sudo docker tag java-devops:latest registry.heroku.com/devops/web
if [ BRANCH_NAME == "master" ] && [ PULL_REQUEST == "false" ]; then sudo docker push registry.heroku.com/java-devops/web; fi

chmod +x heroku-container-release.sh
sudo chown $USER:docker ~/.docker
sudo chown $USER:docker ~/.docker/config.json
sudo chmod g+rw ~/.docker/config.json

./heroku-container-release.sh
