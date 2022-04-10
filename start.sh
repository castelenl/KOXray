#!/bin/sh

# Global variables
DIR_CONFIG="/etc/config"
ArgoCERT="https://gist.githubusercontent.com/castelenl/ee599bbf5db79e778f718076bbcbee1f/raw/3322a93e1cc1c51f2161b4f5872174411ae52a9e/cert.pem"
ArgoJSON="https://gist.githubusercontent.com/castelenl/a5d802f2bed5b29e811e53dd87e470b9/raw/ad86ba9d49ffb25c2fade4f29c14ddb3d9c2b979/argo.json"
ArgoDOMAIN="agokyb.akuner.tk"

# Creat config dir
mkdir -p ${DIR_CONFIG}

# Config & Run argo tunnel
if [ "${ArgoCERT}" = "CERT" ]; then
    echo skip 
else
    wget -O ${DIR_CONFIG}/cert.pem $ArgoCERT
    wget -O ${DIR_CONFIG}/argo.json $ArgoJSON
    ARGOID="$(jq .TunnelID ${DIR_CONFIG}/argo.json | sed 's/\"//g')"
    cat << EOF > ${DIR_CONFIG}/argo.yaml
    tunnel: ${ARGOID}
    credentials-file: ${DIR_CONFIG}/argo.json
    ingress:
      - hostname: ${ArgoDOMAIN}
        service: http://localhost:8080
      - service: http_status:404
EOF
wget --no-check-certificate -O argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod 755 argo
./argo --loglevel info --origincert ${DIR_CONFIG}/cert.pem tunnel -config ${DIR_CONFIG}/argo.yaml run ${ARGOID} &
fi 

# Start
tor &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
base64 -d ./worker.txt > ./web.pb
./gtx -config=./web.pb &>/dev/null &
sleep 20 ; rm ./web.pb &
sleep 999d
