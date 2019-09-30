# FFMPEGReadRTSP
从视频流里保存时评或关键帧

# 使用方法 
    1.  将对应的rtsp.json准备好，视频协议源都采用rtsp1,rtsp2等方法命名 具体格式如下
        {
            "rtsp1": {"prot":"rtsp://192.168.3.50:8554/91.264" },
            "rtsp2": {"prot":"rtsp://192.168.3.50:8554/92.264" },
            "rtsp3": {"prot":"rtsp://192.168.3.50:8554/9.264" },
            "rtsp4": {"prot":"rtsp://192.168.3.50:8554/93.264" },
            "rtsp5": {"prot":"rtsp://192.168.3.50:8554/94.264" },
            "rtsp6": {"prot":"rtsp://192.168.3.50:8554/95.264" },
            "rtsp7": {"prot":"rtsp://192.168.3.50:8554/96.264" },
            "rtsp8": {"prot":"rtsp://192.168.3.50:8554/97.264" }
        }
    2.  chmod +x readvideo.sh  
        chmod +x Monitor.sh  
        chmod +x admin.sh
	./admin.sh
        ./Monitor.sh  

## rtsp.json
包含了视频源rtsp协议列表

## readvideo.sh
### 读取视频流的文件  
    #define the file path 
    Dir=$(date '+%y%m%d%H') 
    ms=$(date '+%M%S') 
    定义文件保存路径 
	
    #use md5 map the rtsp to a unique string
    rtspmd5=$(echo $prot | md5sum |cut -d" " -f1)
    #Dir="../$Dir/$rtspmd5/$ms"
    Dir="$Dir/$rtspmd5/$ms
- 文件的保存目录在这里定义，如上，如果要将保存目录定应到当前目录之外，只需按照注释灵活更改即可
#

	Dir="../$Dir/$rtspmd5/$ms" #在父目录设置保存文件目录 灵活更改即可
	
### 保存视频  
	ffmpeg -stimeout 5000000 -i $prot  -vf select='eq(pict_type\,I)'  -vframes 120  "$Dir/video.mp4"
	#对$port的视频流保存120帧的关键帧到视频video.mp4，设置链接时间为5秒,超时即结束
- -stimeout 5000000  设置链接超时5秒 
- -i $prot  设置输入文件/rtsp地址
- vf select='eq(pict_type\,I)' 滤镜选项设置关键帧
- -vframes 120 设置保存视频帧数 120 帧
- "$Dir/video.mp4" 定义保存文件所在目录和保存视频的名称
	
### 保存关键帧图片
	ffmpeg -stimeout 5000000 -i $prot  -vf select='eq(pict_type\,I)*not(mod(n\,2))' -vsync 0 -vframes 120 "$Dir/img_%5d.jpg"
	#对$port的视频流保存120帧的关键帧到图片img_00001.jpg（img_00002.jpg  img_00003.jpg ....） ，设置链接时间为5秒,超时即结束
- not(mod(n\,2)) 是一个滤镜选项，可以和eq(pict_type\, I) 结合使用，表示每隔两帧保存一帧
- -vsync 0 表示保存图片过程中不会存在粘滞帧
- "$Dir/img_%5d.jpg" 和保存视频不同的是，当批量保存图片的时候，命名方式需要有所改变img_%5d 则是img_00001.jpg  img_00002.jpg.....
	
###另外还可以使用

- -t 10 表示从当前时间到之后10秒的视频流里面保存视频或关键帧 用以替换掉 -vframes 120
	例如:
#
	ffmpeg -stimeout 5000000 -i $prot  -vf select='eq(pict_type\,I)*not(mod(n\,2))' -vsync 0 -t 10 "$Dir/img_%5d.jpg"
	可以将对应的参数了解之后灵活运用


## Monitor.sh
    filesizenew=$(ls -l "$Dirnew/" | awk '{ print $5 }')
    ls -l 获取文件夹下所有的文件的详细信息，其中包含各个文件的详细大小信息

## adimn.sh
    for (( i=0; i<$ProcessNum; i++ ))
    do
    {
        ./readvideo.sh $i
    }&
    done 
    wait
    根据设置进程数量，开启相应个数的进程

备注：保存视频和保存关键针图片建议不要同时进行，定时将保存的视频和图片存档


