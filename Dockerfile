FROM mongo : latest

# Files Preparing
COPY leanote-linux-arm-v2.6.1.bin.tar.gz /data/
COPY entrypoint.sh /usr/local/bin/ 

# Leanote Installing & Timezone Setting
RUN tar zxf /data/leanote-linux-arm-v2.6.1.bin.tar.gz -C /data/; \
	mkdir /data_tmp; \
	mv /data/leanote-linux-arm-v2.6.1.bin.tar.gz /data_tmp/leanote-linux-arm-v2.6.1.bin.tar.gz; \
	chmod a+x /data/leanote/bin/run.sh; \
	SECRET="`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c64 | sed 's/[ \r\b]/a/g'`"; \
	sed -i "s/V85ZzBeTnzpsHyjQX4zukbQ8qqtju9y2aDM55VWxAH9Qop19poekx3xkcDVvrD0y/$SECRET/g" /data/leanote/conf/app.conf; \
	rm -f /etc/localtime; \
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
	rm -f /etc/timezone; \
	echo "Asia/Shanghai" >> /etc/timezone; \
    mkdir /data/backup
	
# Port Setting
EXPOSE 9000

# Script
ENTRYPOINT ["entrypoint.sh"]
