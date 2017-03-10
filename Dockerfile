# This is based on jaysonsantos/minecraft-infinity

FROM phusion/baseimage:0.9.19

MAINTAINER Justin Perron Theberge <theberge.justin@gmail.com>

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get install -y wget unzip openjdk-8-jre-headless && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN addgroup --gid 1234 minecraft && adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft
RUN mkdir -p /tmp/feed-the-beast /etc/service/FTB && touch /version /modpack && chown -R minecraft /tmp/feed-the-beast && chown minecraft /version /modpack

EXPOSE 25565

ADD start.sh /start
ADD FTB.sh /etc/service/FTB/run

VOLUME /data
ADD server.properties /tmp/server.properties
WORKDIR /data

CMD ["/sbin/my_init"]

ENV MOTD A Minecraft (FTB Presents SkyFactory 3) Server Powered by Docker
ENV LEVEL world
ENV JVM_OPTS -Xms2048m -Xmx2048m -Dfml.queryResult=confirm
ENV OPS 7h3ju57
ENV UPDATE yes
ENV MODPACK SkyFactory 3





