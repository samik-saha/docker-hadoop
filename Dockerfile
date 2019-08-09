FROM ubuntu:latest

# Set Hadoop version
ARG HADOOP_VERSION=3.1.2

# Set tar file name to be downloaded
ARG TAR=hadoop-$HADOOP_VERSION.tar.gz

LABEL Description="Hadoop", \
      "Hadoop Version"="$HADOOP_VERSION"

# Add hadoop binaries to PATH
ENV PATH $PATH:/hadoop/bin

# Set working directory to root
WORKDIR /

# Install required software
RUN apt update && \
    apt -y install wget openssh-server openssh-client tar openjdk-8-jdk vim

# Download and extract Apache hadoop software
RUN wget -t 10 --max-redirect 1 --retry-connrefused -O "$TAR" "http://www.apache.org/dyn/closer.lua?filename=hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz&action=download" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "$TAR" "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz" && \
    tar zxf "$TAR" && \
    test -d "hadoop-$HADOOP_VERSION" && \
    ln -sv "hadoop-$HADOOP_VERSION" hadoop

# Remove downloaded tar file and doc folder
RUN rm -fv "$TAR" && \
    rm -rf hadoop/share/doc

# Setup ssh keys for passwordless login for nodes to communicate with each other
RUN mkdir /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keygen -t ecdsa -f /root/.ssh/id_rsa -N "" && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Upload local config files into the container
COPY ./hadoop-config/* /hadoop/etc/hadoop/

# Format name node
RUN hdfs namenode -format

# Expose ports for host system access
EXPOSE 9870 9864 9866

# Run commands when starting the container
ENTRYPOINT /etc/init.d/ssh start && /hadoop/sbin/start-dfs.sh && /bin/bash

