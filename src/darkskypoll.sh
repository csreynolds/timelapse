if [ -z "${CAMERA_NAME}" ]; then 
	CAMERA_NAME=`cat /camera.name`
fi
. /timelapse_data/${CAMERA_NAME}/timelapse.cfg
CONDITIONS_JSON=/usr/local/timelapse/darksky/conditions.json
CONDITIONS_TXT=${TIMELAPSE_DATA}/conditions.txt

#Only run if conditions file is >=5min old
if [ ! `find ${CONDITIONS_TXT} -mmin +5` ] ; then
	echo "`date` - $0: ${CONDITIONS_TXT} not 5min old, skipping this run..."
	exit 0
fi

if [ ! -z "${DARKSKY_API_KEY}" ] && [ ! -z "${CAMERA_LAT}" ] && [ ! -z "${CAMERA_LONG}" ] ; then
	curl https://api.darksky.net/forecast/${DARKSKY_API_KEY}/${CAMERA_LAT},${CAMERA_LONG}?exclude=minutely,hourly,daily,alerts,flags -o ${CONDITIONS_JSON}
	if [ "$?" -gt "0" ]; then
		echo "$0: curl command failed, exiting..."
		sleep 10
		exit 1
	fi
else
	echo "$0: Missing required Darksky api values from /timelapse_data/${CAMERA_NAME}/timelapse.cfg"
	echo "$0: CAMERA_LAT, CAMERA_LONG, and DARKSKY_API_KEY must be populated for conditions to be pulled."
	echo "$0: Check config and try again."
	sleep 10
	exit 1
fi

PULLTIME_EPOCH="`cat ${CONDITIONS_JSON} | jq '.currently.time'`"
PULLTIME="`date -d @${PULLTIME_EPOCH} +%H:%M:%S`"
SUMMARY="`cat ${CONDITIONS_JSON} | jq '.currently.summary'`"
TEMPERATURE="`cat ${CONDITIONS_JSON} | jq '.currently.temperature'`"
PRESSURE="`cat ${CONDITIONS_JSON} | jq '.currently.pressure'`"
WINDSPEED="`cat ${CONDITIONS_JSON} | jq '.currently.windSpeed'`"
WINDGUST="`cat ${CONDITIONS_JSON} | jq '.currently.windGust'`"
WINDBEARING="`cat ${CONDITIONS_JSON} | jq '.currently.windBearing'`"
CLOUDCOVER="`cat ${CONDITIONS_JSON} | jq '.currently.cloudCover'`"

echo > ${CONDITIONS_TXT}
echo "Time:${PULLTIME}" >> ${CONDITIONS_TXT}
echo "Summary:${SUMMARY}" >> ${CONDITIONS_TXT}
echo "Temp:${TEMPERATURE}F" >> ${CONDITIONS_TXT}
echo "Press:${PRESSURE}hPa" >> ${CONDITIONS_TXT}
echo "WSpd:${WINDSPEED}" >> ${CONDITIONS_TXT}
echo "WGst:${WINDGUST}" >> ${CONDITIONS_TXT}
echo "WDir:${WINDBEARING}" >> ${CONDITIONS_TXT}
echo "CldCvrPct:${CLOUDCOVER}" >> ${CONDITIONS_TXT}