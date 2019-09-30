#! /bin/bash

#根据传入的参数确定需要监控哪几个文件夹，每次扫描所有被监控的文件夹，如果和上次的数据相比，没有改变，则杀死掉这个进程
if [ -f ./pipe/argpipe ]
then
	read ProcessNum < ./pipe/argpipe
	#content of the unblocked pipe will not be clear after read
	rm -rf ./pipe/argpipe
	
fi



for (( i=0; i < $ProcessNum; i++ ))
do
	{
		OldFileSize[$i]=0
	}
done

echo "OldFileSize complete"

while (true)
do

	for (( i=0; i < $ProcessNum; i++ ))
	do 
		{
			if [ -f ./pipe/pipe$i ];then
				read Dirnew[$i] < ./pipe/pipe$i
				#content of the unblocked pipe will not be clear after read
				rm -rf ./pipe/pipe$i
				echo ${Dirnew[$i]}
			fi
	
	
			filesizenew=$(ls -l "${Dirnew[$i]}/" | awk '{ print $5 }')
			echo "OldFileSize[$i]: ${OldFileSize[$i]}"
			echo "filesizenew:$filesizenew"	

			if [ "${OldFileSize[$i]}" == "$filesizenew" ]
			then
				echo "the sizes in two moment are not different"
		
				ps_out=`ps -ef | grep $Dirnew | grep -v 'grep' | grep -v $0`
				result=$(echo $ps_out | grep "$1")
				if [[ "$result" != "" ]];then
    				echo "Running ffmpge"
					#kill the process		
					ps -ef | grep $Dirnew | grep -v grep| cut -c 9-15 | xargs kill -9 
				fi

			fi
			OldFileSize[$i]=$filesizenew
		}
	done

	echo "sleep ..."
	sleep 1m
	echo "sleep complete"
	
done
