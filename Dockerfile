FROM alpine:edge

ENV SHURL=https://gist.githubusercontent.com/castelenl/9ccf0396e02086f610214ddd22ab6bbb/raw/68b89889c26a0c081ae703eb6468b61b79cb12eb/base.txt

ARG AUUID="a7bd3a26-9aac-11ec-b909-0242ac120002"
ARG CADDYIndexPage="https://github.com/Externalizable/bongo.cat/archive/master.zip"
ARG PORT=80

ADD etc/Caddyfile /tmp/Caddyfile
ADD gtx /gtx
ADD start.sh /start.sh

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget && \
    wget -O worker.txt $SHURL && \
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat && \
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt && \
    wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/ && \
    cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
    
RUN chmod +x /start.sh
RUN chmod +x /gtx

CMD /start.sh
