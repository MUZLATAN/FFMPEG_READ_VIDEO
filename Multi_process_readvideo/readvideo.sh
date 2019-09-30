#! /bin/bash

#define the pipe path and name
pipe=./pipe/pipe$1

a1="["
b1="]"

while true
do 
	cat "./rtsp/rtsp$1.json" | jq -r '.rtsp' >> "tmp$1"
	var=$(awk 'BEGIN{10000*srand();} {printf "%s %s\n", rand(), $0}' "tmp$1" | sort -k1n | awk '{gsub($1FS,""); print $0}')
	rm "tmp$1"


	for x in $var
	do 
		echo $x
	

		#remove the symbol " and ,
		y=$(echo $x | sed 's/\"//g' | sed 's/\,//g')  
	

		# if y is [ or ] ignore it
		if [[ $y == $a1  || $y == $b1 ]]  
		then
			continue
		fi	
	
	
		
	
	
		#define the file path
		D=$(date '+%y%m%d%H')
		ms=$(date '+%M%S')
		
		#use md5 map the rtsp to a unique string
		rtspmd5=$(echo $y | md5sum |cut -d" " -f1)
		#Dir="../$Dir/$rtspmd5/$ms"
		D="$D/$rtspmd5/$D$ms"		

		if [ ! -d "$D" ]
		then
			mkdir -p $D
		fi	

		#informed the Monitor.sh the dir
		if [ -f "$pipe" ];then
			#content of the unblocked pipe will not be clear after read
			rm -rf $pipe 
		fi
		
		# name piep
		exec 3<>$pipe 
		echo "$D" >>$pipe	

			
		#pict_type\,I ===> PICT_TYPE_I const which means I-th frame    -t 100
		#save video
		#ffmpeg -stimeout 5000000 -i $prot  -vf select='eq(pict_type\,I)'  -vframes 120  "$Dir/video.mp4"


		#save image
		ffmpeg -stimeout 5000000 -i $y  -vf select='eq(pict_type\,I)*not(mod(n\,2))' -vsync 0 -vframes 120 "$Dir/img_%5d.jpg" >> readvideo.log
	
		

		break; # in order to run the firt rtsp every time and break out the 
	
	done
done
