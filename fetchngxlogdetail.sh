#!/bin/sh
set -x
#nginx_log_path=$logdir
#apiurl=$api
apilogfile=APIS
apifilepath=$(pwd)/$apilogfile

dy=$(date +27/%b/%Y)

user_log() {
    echo "----input your logdir----"
    sleep 1
    #    read -p "Please input logdir:" logdir
    #    read -p "Please input request_uri(ex:/v1):" api
    #    echo "logdir='$logdir'\napiurl='$api'"
    #    read -p "make sure path right:(y or n)" flag
    api='/api/v2/history'
    flag='y'
    logdir=$(docker inspect -f {{.LogPath}} $(docker ps | grep 'api.1' | awk {'print $1'}))
}

grep_apilog() {
    nginx_log_path=$logdir
    apiurl=$api
    #for nomal ngxlog  request_uri = $7
    grep "$dy" $nginx_log_path | grep "$apiurl" | awk -v OFS='-----' {'print $1,$4,$7,$9'} |
        sed s/'{"log":"'//g >APIS
    sleep 2
}
re_apilog() {
    rm -rf api_totels
    for i in $(seq -w 00 23); do
        for x in $(seq -w 00 10 50); do
            echo "$dy:$i:$x"
            grep "$dy:$i:$x" APIS | head -1 >>api_totels
        done
    done

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
echo "----please use 'cat api_totels'----"
