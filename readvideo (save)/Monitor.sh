#! /bin/bash

# this bash's function monitor the readvideo.sh 
# if all the file in the directory have not been changed then kill the readvideo.sh

#define the file path

filesize=0

#define the pipe path and name
pipe=./readVideoPipe

while (true)
do

	# judge the testpipe exist or not
	if [ -f "$pipe" ];then
		read Dirnew <$pipe
		#content of the unblocked pipe will not be clear after read
		rm -rf $pipe 
		echo $Dirnew
	fi
	
	
	filesizenew=$(ls -l "$Dirnew/" | awk '{ print $5 }')
	echo "filesize: $filesize"
	echo "filesizenew:$filesizenew"	

	if [ "$filesize" = "$filesizenew" ]
	then
		echo "the sizes in two moment are not different"
		
		ps_out=`ps -ef | grep ffmpeg | grep -v 'grep' | grep -v $0`
		result=$(echo $ps_out | grep "$1")
		if [[ "$result" != "" ]];then
    			echo "Running ffmpge"
			#kill the process		
			ps -ef | grep ffmpeg | grep -v grep| cut -c 9-15 | xargs kill -9 
		fi

	fi
	filesize=$filesizenew

	echo "sleep ..."
	sleep 1m
	echo "sleep complete"
	
done
