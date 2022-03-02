#!/bin/bash

CONFIG_FILE_NAME=backup.conf
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CONFIG_FILE=$SCRIPT_DIR/$CONFIG_FILE_NAME

DB_NAMES=$(grep db_names $CONFIG_FILE | cut -d= -f2)
DB_NAMES_ARR=(${DB_NAMES//,/ })
BACKUP_DIR=$(grep backup_dir $CONFIG_FILE | cut -d= -f2)
BACKUP_DAYS=$(echo $(grep backup_days $CONFIG_FILE | cut -d= -f2))
MYSQLDUMP_CMD=$(grep mysqldump_cmd $CONFIG_FILE | cut -d= -f2)

DATE=`date +%Y%m%d`
TIME=`date +%H%M%S`

echo "[$DATE $TIME]"
echo "Backuping ..."
for DB_NAME in ${DB_NAMES_ARR[@]}
do
    TODAY_DIR=$BACKUP_DIR/$DATE
    if [ ! -d $TODAY_DIR ]; then
        mkdir -p $TODAY_DIR
    fi

    echo -n "  BACKUP $DB_NAME ... "
    $MYSQLDUMP_CMD --defaults-extra-file=$CONFIG_FILE --triggers --routines --events $DB_NAME | gzip > $TODAY_DIR/$DB_NAME.$TIME.sql.gz
    echo "[OK]"
done
echo "Backup End!"

# delete the backup files before n days
# 删除 n 天前的备份数据
DELETED_BACKUP_DIRS=$(find $BACKUP_DIR -type d -ctime +$BACKUP_DAYS)
echo "Deleting old data ..."
for DELETED_DIR in $DELETED_BACKUP_DIRS
do
    rm -rf $DELETED_DIR > /dev/null 2>&1
    echo "  $DELETED_DIR ... [DONE]"
done
echo "Delete End!"