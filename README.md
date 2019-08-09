# docker-hadoop
It uses latest ubuntu linux as base, and runs apache hadoop 3.1.2. on top of it. We are using Java 8 (openjdk-8) that is compatible with Hadoop 3.1.2. We are running all the nodes as `root` user.

## Build Docker image from source (GitHub)
    docker build -t hadoop:latest .

## Run Docker image
    docker run -it -h localhost --name hadoop -p 9870:9870 -p 9864:9864 -p 9866:9866 hadoop

* container host name has been set to localhost so that the hdfs directory can be accessed from host using the url localhost:9870 which redirects the datanode at localhost:9864 for upload/download.

The web interface for the namenode can be accessed from host system at http://localhost:9870. Go to `Utilities -> Browse the file system` to access the HDFS directory. Here also, the user has been set to `root` (default was dr.who) to give read/write acess.
