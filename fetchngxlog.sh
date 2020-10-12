#!/bin/sh
set -x
#nginx_log_path=$logdir
#apiurl=$api
apilogfile=API
apifilepath=$(pwd)/$apilogfile

d=$(date +%d/%b/%Y)
user_log() {
    echo "----input your logdir----"
    sleep 1
    #    read -p "Please input logdir:" logdir
    #    read -p "Please input request_uri(ex:/v1):" api
    #    echo "logdir='$logdir'\napiurl='$api'"
    #    read -p "make sure path right:(y or n)" flag
    api='/api'
    flag='y'
    logdir=$(docker inspect -f {{.LogPath}} $(docker ps | grep 'api.1' | awk {'print $1'}))
}

grep_apilog() {
    nginx_log_path=$logdir
    apiurl=$api

    #for nomal ngxlog  request_uri = $7
    cat $nginx_log_path |grep "$d" | awk {'print $7'} | grep "^$apiurl" | sed s/\?.*//g >$apilogfile
    sleep 2
}
re_apilog() {
    cat $apilogfile | sort -rn | uniq -c >api_totel
    sleep 2
}
#run
user_log

while [ $flag != "y" ]; do
    echo "try again"
    user_log
done
echo "$nginx_log_path"
echo "----log process----"
grep_apilog
echo "----sourcelogfilepath '$apifilepath' ----"
echo "----totelapi----"
re_apilog
echo "----please use 'cat api_totel'----"
