# docker-hadoop
Run hadoop on docker in pseudo-distributed mode

## Build Docker image
    docker build .

## Run Docker image
    docker run -it -h localhost --name hadoop -p 9870:9870 -p 9864:9864 -p 9866:9866 hadoop /bin/bash

