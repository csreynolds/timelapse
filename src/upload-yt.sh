if [ -z "${CAMERA_NAME}" ]; then 
	CAMERA_NAME=`cat /camera.name`
fi
. /timelapse_data/${CAMERA_NAME}/timelapse.cfg

# youtube-upload --  https://github.com/tokland/youtube-upload 
# SETUP for --client-secrets and -credentials-file listed at link above
if [ ! -f "${YOUTUBE_CLIENT_SECRETS}" ] ; then
	echo "${0}: YouTube Client Secrets file is missing, cannot authenticate..." >&2
	sleep 10
	exit 1
else
	ARGS="${ARGS} --client-secrets=${YOUTUBE_CLIENT_SECRETS}"
fi
if [ ! -f "${YOUTUBE_CREDENTIALS_FILE}" ] ; then
	echo "${0}: YouTube Credentials file is missing, cannot authenticate..." >&2
	sleep 10
	exit 1
else
	ARGS="${ARGS} --credentials-file=${YOUTUBE_CREDENTIALS_FILE}"
fi
FILE=${1}
if [ ! -f "${FILE}" ] ; then
        echo "${0}: Cannot open file '${FILE}'!" >&2
	sleep 10
        exit 1 
fi

#Get video title from filename
TITLE=$(basename $FILE .mp4)
TITLE=${TITLE//_/\/}
ARGS="${ARGS} --title "${TITLE}""

#Build out args list
if [ ! -z "${YOUTUBE_CAMERA_DESCRIPTION}" ] ; then
	ARGS="${ARGS} --description='${YOUTUBE_CAMERA_DESCRIPTION}'"
fi
if [ ! -z "${YOUTUBE_CAMERA_PLAYLIST}" ] ; then
	ARGS="${ARGS} --playlist='${YOUTUBE_CAMERA_PLAYLIST}'"
fi
if [ ! -z "${CAMERA_LAT}" ] && [ ! -z "${CAMERA_LONG}" ] ; then
	ARGS="${ARGS} --location=latitude=${CAMERA_LAT},longitude=${CAMERA_LONG}"
fi
if [ ! -z "${YOUTUBE_CAMERA_TAGS}" ] ; then
	ARGS="${ARGS} --tags='${YOUTUBE_CAMERA_TAGS}'"
fi

#Set recording date from filename
LAST_DATE_FOLDER=`ls -d ${RAW_IMAGE_DIR}/*/ |tail -1 |awk -F/ '{print $(NF-1)}'`
ARGS="${ARGS} --recording-date='${LAST_DATE_FOLDER}T00:01:00.0Z'"

#Default to unlisted
ARGS="${ARGS} --privacy=unlisted"


#DEBUG
#echo ARGS=${ARGS}
#echo FILE=${FILE}

echo "/usr/local/bin/youtube-upload ${ARGS} ${FILE}" > /tmp/${LAST_DATE_FOLDER}-upload.$$
bash /tmp/${LAST_DATE_FOLDER}-upload.$$

if [ "${?}" -eq "0" ] ; then
	exit 0
else
	exit 1
fi