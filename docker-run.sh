#!/usr/bin/zsh
echo "Volume: $(cat volume-paths)"
docker run -p 7777:80 -p 8888:8080 --name ubuntu-4-dev -v $(cat volume-paths) ubuntu-4-dev