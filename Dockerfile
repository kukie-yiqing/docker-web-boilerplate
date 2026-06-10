FROM alpine:latest
RUN apk add --no-cache jq curl bash

# Automatically fetch the latest official Sing-box release binary (musl version for Alpine compatibility)
RUN VERSION=$(curl -s https://api.github.com/repos/sagernet/sing-box/releases/latest | jq -r .tag_name | sed 's/v//') \
    && wget https://github.com/sagernet/sing-box/releases/download/v${VERSION}/sing-box-${VERSION}-linux-amd64-musl.tar.gz \
    && tar -zxvf sing-box-${VERSION}-linux-amd64-musl.tar.gz \
    && mv sing-box-${VERSION}-linux-amd64-musl/sing-box /usr/local/bin/ \
    && rm -rf sing-box-*

WORKDIR /etc/sing-box
COPY config.json .

# Read dynamic variables and replace placeholders at container start
CMD export TEMP_PORT=${PORT:-8080} && \
    export TEMP_UUID=${UUID:-77777777-7777-7777-7777-777777777777} && \
    export TEMP_PATH=${WS_PATH:-/tech-stream} && \
    sed -i "s/8080/${TEMP_PORT}/g" config.json && \
    sed -i "s/MY_UUID/${TEMP_UUID}/g" config.json && \
    sed -i "s|MY_PATH|${TEMP_PATH}|g" config.json && \
    sing-box run -c config.json
