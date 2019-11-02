# timelapse
Set of scripts run in a docker to capture RTSP stream, create a timelapse and upload to youtube.


Edit .env to fit your filestructure

Edit docker-compose.yml to fit your local setup.

docker-compose.yml example is for 2 cameras, with descriptive names.

```code
docker-compose build

#This creates the individual `.env:DOCKERCONFDIR/docker-compose.yml:CAMERA_NAME/` folder structure.
docker-compose up -d
docker-compose down
```
edit the .env:DOCKERCONFDIR/docker-compose.yml:CAMERA_NAME/timelapse.cfg to fit your config.

```code
docker compose up -d
```

ffmpeg cron run outputs to /var/log/cron.log for debugging if needed.
