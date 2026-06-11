FROM ghcr.io/sagernet/sing-box:latest

USER root
RUN apk add --no-cache bash sed

WORKDIR /var/box
COPY config.json /var/box/config.json

ENTRYPOINT []
EXPOSE 7860

CMD ["/bin/bash", "-c", "export TEMP_UUID=${UUID:-77777777-7777-7777-7777-777777777777} && export TEMP_PATH=${WS_PATH:-/tech-stream} && sed -i \"s/MY_UUID/${TEMP_UUID}/g\" config.json && sed -i \"s|MY_PATH|${TEMP_PATH}|g\" config.json && sing-box run -c config.json"]