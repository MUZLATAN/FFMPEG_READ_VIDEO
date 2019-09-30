#! /bin/bash

#循环查看是否有ffmpeg进程在内存当中运行，如果有，将其kill

while (true)
do
    ps_out=`ps -ef | grep ffmpeg | grep -v 'grep' | grep -v $0`
	result=$(echo $ps_out | grep "$1")
    if [[ "$result" != "" ]];then
    	echo "Running ffmpge"
		#kill the process		
		ps -ef | grep ffmpeg | grep -v grep| cut -c 9-15 | xargs kill -9 
        ps -ef | grep readvideo | grep -v grep| cut -c 9-15 | xargs kill -9 
    else
        break

    fi


done