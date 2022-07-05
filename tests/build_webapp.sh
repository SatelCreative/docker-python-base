#!/usr/bin/env bash

docker build --build-arg DEVFLAG=--dev -t webapp_dev .

docker build -t webapp_prd .

docker run webapp_dev validatecodeonce; STATUS1=$?

docker run -p 8000:8000 -d webapp_prd

sleep 5

curl -L http://localhost:8000/; STATUS2=$?

TOTAL=$((STATUS1 + STATUS2))
exit $TOTAL
