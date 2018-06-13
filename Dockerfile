FROM openjdk:8-jdk
MAINTAINER libra@ljing.wang
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG user=server
ARG group=server
ARG uid=1000
ARG gid=1000
ARG ARG_HOME=/usr/share/work
ENV HOME ${ARG_HOME}
ENV USER server

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list

ENV GOSU_VERSION 1.10

RUN  arch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$arch" \
&& chmod +x /usr/local/bin/gosu \
&& gosu nobody true


ENV PATH /usr/share/work:/usr/local/bin:/usr/local/bin/gosu:$PATH

RUN apt-get update && apt-get install net-tools
RUN apt-get update && apt-get install vim -y
RUN apt-get update && apt-get install telnet

RUN groupadd -g ${gid} ${group} \
    && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

WORKDIR ${ARG_HOME}