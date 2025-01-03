FROM debian:stable-slim

COPY BootDocker /bin/BootDocker

CMD [ "/bin/BootDocker" ]
