#!/bin/bash

set -e

echo "$MODPACK" > /modpack
touch /version && chown -R minecraft /version /modpack

if [[ "$MODPACK" != $(cat /modpack) ]] && [[ -e /tmp/feed-the-beast ]]; then
	rm -r /tmp/feed-the-beast/*
fi

if [[ "$UPDATE" == "yes" ]]; then
	BASE="https://www.feed-the-beast.com"
	a=$(wget -qO- "$BASE"/modpacks | grep -io ".*href=.*$MODPACK.*" | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | xargs | head -n 1)
	b="$(wget -qO- "$BASE""$a" | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep file | grep -v latest | grep -v download | grep -v filter | sort -r | head -n 1)"
	c="$(wget -qO- "$BASE""$b" | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep download | sort -r | head -n 1)"
	if [[ $(echo "$c" | cut -d"/" -f5) != $(cat /version) ]]; then
		wget "$BASE""$c" -O /tmp/FTBModpack.zip && echo "$c" | cut -d"/" -f5 > /version
	fi
	if [[ -e /tmp/feed-the-beast/config ]]; then
		rm -r /tmp/feed-the-beast/{config,mods,resources,libraries,scripts,FTBserver*universal.jar}
	fi
	mkdir -p /tmp/feed-the-beast \
		&& cd /tmp/feed-the-beast \
		&& unzip /tmp/FTBModpack.zip \
		&& rm /tmp/FTBModpack.zip \
		&& bash -x FTBInstall.sh \
		&& chown -R minecraft /tmp/feed-the-beast
fi
cd /data
cp -rf /tmp/feed-the-beast/* .
echo "eula=true" > eula.txt

if [[ ! -e server.properties ]]; then
    cp /tmp/server.properties .
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

java $JVM_OPTS -jar FTBserver-*.jar nogui
