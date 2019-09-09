FROM arm64v8/mongo

# Preparing
ENV SITEURL=http://localhost:9000
ENV ADMINUSER=admin
ENV LANG=en-us
COPY leanote-linux-arm-v2.6.1.bin.tar.gz /data/
COPY entrypoint.sh /usr/local/bin/

# Leanote Installing
RUN tar zxf /data/leanote-linux-arm-v2.6.1.bin.tar.gz -C /data/; \
        mkdir /data_tmp; \
        mv /data/leanote-linux-arm-v2.6.1.bin.tar.gz /data_tmp/leanote-linux-arm-v2.6.1.bin.tar.gz; \
        chmod a+x /data/leanote/bin/run.sh; \
        # Security Setting on Leanote Wiki
        SECRET="`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c64 | sed 's/[ \r\b]/a/g'`"; \
        sed -i "s/V85ZzBeTnzpsHyjQX4zukbQ8qqtju9y2aDM55VWxAH9Qop19poekx3xkcDVvrD0y/$SECRET/g" /data/leanote/conf/app.conf; \
        # Timezone Setting
        rm -f /etc/localtime; \
        ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
        rm -f /etc/timezone; \
        echo "Asia/Shanghai" >> /etc/timezone; \
        # Backup DIR
        mkdir /data/backup
        # Script Initializing
        chmod a+x /usr/local/bin/entrypoint.sh

# Port Setting
EXPOSE 9000

# Script
ENTRYPOINT ["entrypoint.sh"]
