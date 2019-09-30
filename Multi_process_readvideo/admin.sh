#! /bin/bash

#设置开启的进程数量,
ProcessNum=10


#采用通道，传参数给Monitor.sh
exec 3<> ./pipe/argpipe 
echo $ProcessNum >> ./pipe/argpipe	



#获取rtsp源的个数
RtspNum=$(cat rtsp.json| jq '.rtsp|length')
echo "$RtspNum"

#每组的个数，如果除不尽， 则余数个的rtsp放到最后一个json文件
ArrNum=$(expr $RtspNum / $ProcessNum)
echo "$ArrNum"


#读取已有的json列表
for ((i=0; i < ProcessNum; i++))
do
	tmpfile="./rtsp/rtsp$i.json"

	echo "{" >> $tmpfile
	echo "\"rtsp\":" >> $tmpfile
	echo "[" >> $tmpfile

	#前ProcessNum个json文件每个文件有ArrNum个rtsp
	if [ $i != $(expr $ProcessNum - 1 ) ]
	then
		#将i*ArrNum 开始到 第ArrNum-1个rtsp  加 ' , ' 存入到文件  （注意这里有一个逗号）
		for ((j=$(expr $i \* $ArrNum ); j < $(expr $i \* $ArrNum + $ArrNum - 1 ); j++ ))
		do
			 tmp=$(cat rtsp.json | jq -r ".rtsp[$j]")
			 echo "\"$tmp\"," >> $tmpfile
		done
		#将最后一条 rtsp存入到文件，去掉 ' , ' 存入文件 （这里没有逗号，json 格式要求）
		tmp=$(cat rtsp.json | jq -r ".rtsp[$j]")
		echo " \"$tmp\" " >> $tmpfile
		

	else
		#最后一个json，将i*ArrNum 开始到倒数第二个rtsp加 ' , '   存入到文件
		for ((j=$(expr $i \* $ArrNum ); j < $(expr $RtspNum - 1 ); j++ ))
		do
			 tmp=$(cat rtsp.json | jq -r ".rtsp[$j]")
			 echo " \"$tmp \" ," >> $tmpfile
		done

		tmp=$(cat rtsp.json | jq -r ".rtsp[$j]")
		echo " \"$tmp\" " >> $tmpfile
		echo $j
	fi


	echo "]" >> $tmpfile
	echo "}" >> $tmpfile

done

开ProcessNum 个进程，并传入参数，第一个进程处理第一个json文件
for (( i=0; i<$ProcessNum; i++ ))
do
	{
		./readvideo.sh $i
		
	}&
done 
wait

