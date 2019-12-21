#!/usr/bin/zsh
echo "Volume: $(cat volume-paths)"
docker run -p 7777:80 --name ubuntu-4-dev -v $(cat volume-paths) ubuntu-4-dev