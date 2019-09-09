#!/bin/bash
set -e

# Start MongoDB
mongod &

# Check Leanote state
echo Checking Leanote status...
if [ ! -d "/data/leanote" ]; then
        echo Leanote is not installed
        echo Installing Leanote...
        tar zxf /data_tmp/leanote-linux-arm-v2.6.1.bin.tar.gz -C /data/
        chmod a+x /data/leanote/bin/run.sh
        SECRET="`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c64 | sed 's/[ \r\b]/a/g'`"
        sed -i "s/V85ZzBeTnzpsHyjQX4zukbQ8qqtju9y2aDM55VWxAH9Qop19poekx3xkcDVvrD0y/$SECRET/g" /data/leanote/conf/app.conf
        mkdir /data/backup
fi
sed -i "48ci18n.default_language=$LANG" /data/leanote/conf/app.conf
sed -i "11cadminUsername=$ADMINUSER" /data/leanote/conf/app.conf
sed -i "8csite.url=$SITEURL" /data/leanote/conf/app.conf
echo -e "\033[32mLeanote is installed \033[0m"

# Check mongodb data
echo Checking MongoDB status...
if [ ! -f "/data/db/.do_not_delete" ]; then
        echo No database
        echo Initializing MongoDB...
        mongorestore -h localhost -d leanote --dir /data/leanote/mongodb_backup/leanote_install_data/
        echo "do not delete this file" >> /data/db/.do_not_delete
        chmod 400 /data/db/.do_not_delete
        echo Done
fi
echo -e "\033[32mMongoDB is initialized \033[0m"

# Start Leanote
echo `date "+%Y-%m-%d %H:%M:%S"`' >>>>>> start leanote service'
/data/leanote/bin/run.sh &

# Auto Backup
BACKUP_DIR=/data/backup
DAYS=7
HOUR=`date "+%-H"`
MIN=`date "+%-M"`
SEC=`date "+%-S"`
seconds=$((10#24*3600-${HOUR}*3600-${MIN}*60-${SEC}))
sleep $seconds
echo ++++++++Star Counting++++++++
while true; do
        TIME=`date "+%Y%m%d_%H%M"`
        mongodump -h 127.0.0.1:27017 -d leanote -o $BACKUP_DIR/
        tar -zcvf $BACKUP_DIR/mongodb_bak_$TIME.tar.gz $BACKUP_DIR/leanote
        tar -zcvf $BACKUP_DIR/leanote_bak_$TIME.tar.gz /data/leanote
        rm -rf $BACKUP_DIR/leanote
        find $BACKUP_DIR/ -mtime +$DAYS -delete
        HOUR=`date "+%H"`
        MIN=`date "+%M"`
        SEC=`date "+%S"`
        seconds=$((10#24*3600-${HOUR}*3600-${MIN}*60-${SEC}))
        sleep $seconds
done

exec "$@"
