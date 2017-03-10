#!/bin/bash

set -e

touch /data/version
if [[ "$UPDATE" == "yes" ]]; then
	BASE="https://www.feed-the-beast.com"
	a=$(wget -qO- "$BASE"/modpacks | grep -io ".*href=.*$MODPACK.*" | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | xargs | head -n 1)
	b="$(wget -qO- "$BASE""$a" | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep file | grep -v latest | grep -v download | grep -v filter | sort -r | head -n 1)"
	c="$(wget -qO- "$BASE""$b" | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' | grep download | sort -r | head -n 1)"
	if [[ $(echo "$c" | cut -d"/" -f5) != $(cat /data/version) ]]; then
		wget "$BASE""$c" -O /tmp/FTBModpack.zip && echo "$c" | cut -d"/" -f5 > /data/version
		if [[ -e /data/config ]]; then
			rm -r /data/{config,mods,resources,libraries,scripts,FTBserver*universal.jar,version.json}
		fi
		mkdir -p /tmp/ftb && cd /tmp/ftb \
			&& unzip /tmp/FTBModpack.zip \
			&& rm /tmp/FTBModpack.zip \
			&& cd /data && cp -rf /tmp/ftb/* /data \
			&& bash -x FTBInstall.sh
	fi
fi
cd /data
#if [[ "$UPDATE" == "no" ]]; then
#	cp -rf /tmp/feed-the-beast/* .
#fi
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
