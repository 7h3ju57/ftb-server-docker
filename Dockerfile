# This is based on jaysonsantos/minecraft-infinity

FROM openjdk:8

MAINTAINER Justin Perron Theberge <theberge.justin@gmail.com>

RUN apt-get update && apt-get -y upgrade && apt-get install -y wget unzip
RUN apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN addgroup --gid 1234 minecraft
RUN adduser --disabled-password --home=/data --uid 1234 --gid 1234 --gecos "minecraft user" minecraft
RUN mkdir -p /tmp/feed-the-beast && touch /version /modpack && chown -R minecraft /tmp/feed-the-beast && chown minecraft /version /modpack
USER minecraft

EXPOSE 25565

ADD start.sh /start

VOLUME /data
ADD server.properties /tmp/server.properties
WORKDIR /data

CMD /start

ENV MOTD A Minecraft (FTB Presents SkyFactory 3) Server Powered by Docker
ENV LEVEL world
ENV JVM_OPTS -Xms2048m -Xmx2048m
ENV OPS 7h3ju57
ENV UPDATE yes
ENV MODPACK SkyFactory 3





