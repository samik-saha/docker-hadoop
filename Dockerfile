FROM ubuntu:latest

ARG HADOOP_VERSION=3.1.2

ARG TAR=hadoop-$HADOOP_VERSION.tar.gz

ENV PATH $PATH:/hadoop/bin

LABEL Description="Hadoop Dev", \
      "Hadoop Version"="$HADOOP_VERSION"

ENV PATH $PATH:/hadoop/bin

WORKDIR /

RUN apt update && \
    apt -y install wget openssh-server openssh-client tar openjdk-8-jdk vim

RUN wget -t 10 --max-redirect 1 --retry-connrefused -O "$TAR" "http://www.apache.org/dyn/closer.lua?filename=hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz&action=download" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "$TAR" "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-$HADOOP_VERSION.tar.gz" && \
    tar zxf "$TAR" && \
    test -d "hadoop-$HADOOP_VERSION" && \
    ln -sv "hadoop-$HADOOP_VERSION" hadoop

RUN rm -fv "$TAR" && \
    { rm -rf hadoop/share/doc; : ; } && \
    export JAVA_HOME=/usr

RUN mkdir /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keygen -t ecdsa -f /root/.ssh/id_rsa -N "" && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

COPY ./hadoop-config/* /hadoop/etc/hadoop/

RUN hdfs namenode -format

EXPOSE 9870 9864 9866

ENTRYPOINT /etc/init.d/ssh start && /hadoop/sbin/start-dfs.sh && /bin/bash

