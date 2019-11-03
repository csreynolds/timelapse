#/bin/bash

#Install youtube-upload and depends
pip3 install --upgrade google-api-python-client oauth2client progressbar2
wget https://github.com/tokland/youtube-upload/archive/master.zip
unzip master.zip
pushd youtube-upload-master
# ADD THIS PATCH HERE
#https://github.com/deepdrive/youtube-upload/commit/7d8e0bb6d48cc8b6d9620cbbc5363d3719998a6f
sed -i '/import webbrowser/a from oauth2client import file' youtube_upload/main.py
python3 setup.py install
popd
rm -rf youtube-upload-master
rm -rf master.zip

#Grab weather icons and create darksky structure
mkdir -p /usr/local/timelapse/darksky
pushd /usr/local/timelapse/darksky
#http://adamwhitcroft.com/climacons/
wget https://github.com/AdamWhitcroft/climacons/archive/master.zip
unzip master.zip
rm -rf master.zip

