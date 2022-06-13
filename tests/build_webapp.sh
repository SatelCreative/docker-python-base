#!/usr/bin/env bash

docker build --target webapp_dev -t webapp_dev .

docker build --target webapp_prd -t webapp_prd .

docker run webapp_dev validatecodeonce; STATUS1=$?

docker run -p 8000:8000 webapp_prd startapp

sleep 5

curl -L http://localhost:8000/; STATUS2=$?

TOTAL=$((STATUS1 + STATUS2))
exit $TOTAL



