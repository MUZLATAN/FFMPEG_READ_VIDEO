# FFMPEGReadRTSP
ffmpeg read rtsp or rtmp from a json file (key frame, timeout)
## rtsp.json
	this file is a source of the trsps and rtmps and some of them are cannot be used while some can.
## rt.json
	like rtsp.json
## readvideo.sh
	it is a bash file
	1. ergodic the the rtsp.json
	2. read keys randomly(require the euqal chance)
	3. accroding the keys find the rtmp/rtsp 
	4. use the ffmpeg to read frames from the vedio source
## the useage of the awk is important
	var=$(awk 'BEGIN{10000*srand();} {printf "%s %s\n", rand(), $0}' tmp | sort -k1n | awk '{gsub($1FS,""); print $0}')  
	in order to sort the content of the tmp file randomly
## Monitor.sh
	it is a monitor program, it will monitor the directory of the ffmpeg video ,if the ffmpeg is blocking， this program   will kill the readvideo.sh and it will inform the fathershell.sh 
	
## fathershell.sh
	when it received the infromation from the Monitor.sh by the pipe , it will fork a new process（readvideo.sh）  
	
**pict_type (video only)**  
The type of the filtered frame. It can assume one of the following values:  
**I  
P  
B  
S  
SI  
SP  
BI**  
**ffmpeg -i $input  -vf select='eq(pict_type\,I)'  $outfile**  
