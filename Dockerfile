FROM openjdk:8-jdk
MAINTAINER libra@ljing.wang
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG user=libra
ARG group=libra
ARG uid=1000
ARG gid=1000
ARG ARG_HOME=/usr/share/work
ENV HOME ${ARG_HOME}
ENV PATH /usr/share/work:$PATH

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list

RUN apt-get update && apt-get install net-tools
RUN apt-get update && apt-get install vim -y
RUN apt-get update && apt-get install telnet

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

WORKDIR ${ARG_HOME}