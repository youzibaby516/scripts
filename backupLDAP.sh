#!/bin/bash
set -e
#ldapconf
BACKUP_PATH=/export/backup
SLAPCAT=/usr/sbin/slapcat
DC1="youzibaby"
DC2="com"

#do bakup
$SLAPCAT -b cn=config >$BACKUP_PATH/config_$(date +%Y%m%d).ldif
$SLAPCAT -b dc=$DC1,dc=$DC2 >$BACKUP_PATH/data_$(date +%Y%m%d).ldif

#del one month age
find $BACKUP_PATH -mtime +30 -type f -name \*.ldif | xargs rm -rf
