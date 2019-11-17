FROM ubuntu:16.04

MAINTAINER Keon Ye "keon.ye@qq.com"

ADD sources.list /etc/apt/
COPY config.tar.gz /tmp/

RUN apt-get update && \
    apt-get install -y \
    vim git net-tools wget \
    curl silversearcher-ag zsh

RUN tar -zxvf /tmp/config.tar.gz -C /root/ && \
    rm -rf /tmp/config.tar.gz


ADD zsh_config.sh /root/




