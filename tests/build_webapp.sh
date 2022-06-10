#!/usr/bin/env bash
docker build --target webapp_dev -t webapp_dev .

docker build --target webapp_prd -t webapp_prd .

docker run -it webapp_dev validateonce; STATUS1=$?

exit $STATUS1

docker run -p 8000:8000 -it -d webapp_prd startapp

sleep 5

curl -L http://localhost:8000/; STATUS2=$?

exit $STATUS2

