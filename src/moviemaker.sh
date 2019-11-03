if [ -z "${CAMERA_NAME}" ]; then 
	CAMERA_NAME=`cat /camera.name`
fi
. /timelapse_data/${CAMERA_NAME}/timelapse.cfg

date="$(date "+%Y-%m-%d")"

#Wait for 5min to grab all images from current day
sleep 300

mkdir -p ${RAW_IMAGE_DIR}/${date}
mv ${RAW_IMAGE_DIR}/${date}_* ${RAW_IMAGE_DIR}/${date}/

ffmpeg -f image2 -i ${RAW_IMAGE_DIR}/${date}/%*.jpg -vcodec libx264 -r 60 -strftime 1 ${PROCESSED_VID_DIR}/"${date}-${CAMERA_NAME}".mp4 -y

#Clean out old data
find ${RAW_IMAGE_DIR} -type d -ctime +${DAYS_TO_KEEP} -exec rm -rf '{}' \;


#Post processed video to YouTube
/usr/local/timelapse/upload-yt.sh ${PROCESSED_VID_DIR}/"${date}-${CAMERA_NAME}".mp4

