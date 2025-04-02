#!/bin/bash

CONTAINER_NAME=v2ray
CONTAINER_ID=$(sudo docker ps -aqf "name=$CONTAINER_NAME")
sudo docker exec -it $CONTAINER_ID systemctl start v2ray