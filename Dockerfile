FROM ubuntu:19.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; apt-get install -y ffmpeg vlc cron; \
	apt-get -y install wget python3-distutils python3-pip; \
	touch /etc/crontab /etc/cron.*/*; \
	touch /var/log/cron.log; \
	rm -rf /var/lib/apt/lists/*

COPY src/* /usr/local/timelapse/

RUN chmod +x /usr/local/timelapse/*.sh && /bin/bash /usr/local/timelapse/install.sh

#Fix cron a little :)
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so/' /etc/pam.d/cron

VOLUME /timelapse_data/

ENV CAMERA_NAME=${CAMERA_NAME}
RUN export CAMERA_NAME=${CAMERA_NAME}
#ENV CAMERA_RTSP

CMD ["/bin/bash", "/usr/local/timelapse/init.sh"]