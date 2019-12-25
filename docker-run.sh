#!/usr/bin/zsh
docker run -d -p 7777:80 -p 8888:8080 --name ubuntu-4-dev $(cat volume-paths) ubuntu-4-dev