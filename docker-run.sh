#!/usr/bin/zsh
docker run -d -p 7777:80 -p 8888:8080 -p 3000:3000 -p 4000:4000 --name ubuntu-4-dev $(cat volume-paths) ubuntu-4-dev
