FROM postgres
RUN apt update
RUN apt install curl wget  -y
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /
# set timezone for container
RUN cp  /usr/share/zoneinfo/Europe/Zurich /etc/localtime

RUN wget https://github.com/exoscale/cli/releases/download/v1.49.2/exoscale-cli_1.49.2_linux_arm64.deb
RUN dpkg -i exoscale-cli_1.49.2_linux_arm64.deb
WORKDIR /
COPY pg_dump-to-s3.sh .
COPY pg_dump-to-s3.conf .

ENTRYPOINT ["/init"]
CMD ["sh", "-c",  "pg_dump-to-s3.sh"]
