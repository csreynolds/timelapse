if [ -z "${CAMERA_NAME}" ]; then 
	CAMERA_NAME=`cat /camera.name`
fi
. /timelapse_data/${CAMERA_NAME}/timelapse.cfg

if [ ! -d "${RAW_IMAGE_DIR}" ] ; then
	mkdir -p ${RAW_IMAGE_DIR}
fi

if [ -z "cat ${CONDITIONS_OVERLAY_TXT_FILE}" ] && [ -f "${CONDITIONS_OVERLAY_FONT_FILE}" ] ; then
	for SEC in 00 15 30 45;
	do 
		ffmpeg -y -i ${CAMERA_RTSP} -vf drawtext="textfile=${CONDITIONS_OVERLAY_TXT_FILE}:fontfile=${CONDITIONS_OVERLAY_FONT_FILE}:box=1:x=w-tw-10:y=h-th-10:fontsize=24:boxborderw=5:boxcolor=black@0.7:fontcolor=white:reload=1" -rtsp_transport udp -r 25 -an  -vframes 1 -strftime 1 "${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
		sleep 14
	done
	else
	for SEC in 00 15 30 45;
	do 
		ffmpeg -y -i ${CAMERA_RTSP} -rtsp_transport udp -r 25 -an -vframes 1 -strftime 1 "${RAW_IMAGE_DIR}/%Y-%m-%d_%H-%M-${SEC}.jpg"
		sleep 14
	done
fi
