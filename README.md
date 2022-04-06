# 某容器雲部署Xray高性能代理服務

在某容器雲部署Xray高性能代理服務，通過ws傳輸的(vmess、vless、trojan、shadowsocks、socks)等協議

說明：https://owo.misaka.rest/koyeb-xray/

# 請勿使用常用的賬號部署此項目，以免封號！！

## 部署步驟

1. fork本倉庫
2. 在`Dockerfile`內第3-5行修改自定義設置，說明如下：

`AUUID`：用來部署節點的UUID，如有需要可在[uuidgenerator](https://www.uuidgenerator.net/)生成

`CADDYIndexPage`：僞裝站首頁文件

`ParameterSSENCYPT`：ShadowSocks加密協議

3. 去[Docker Hub](https://hub.docker.com/)註冊一個賬號，如有賬號可跳過
4. 編輯Actions文件`docker-image.yml`，按照“name: Docker Hub ID/自定義鏡像名稱”格式修改第13行
5. 添加Actions的Secrets變量，變量說明如下

`DOCKER_USERNAME`：Docker Hub ID

`DOCKER_PASSWORD`：Docker Hub 登錄密碼

6. 打開某容器雲主頁，新建一個應用
7. 應用配置如下所示

`Docker Image`：Docker Hub鏡像地址，格式爲“docker.io/Docker Hub ID/自定義鏡像名稱”

`Container size`：部署配置，一般默認即可

`Port`：80

Environment variables：`Key`：PORT，`Value`：80
`Name`：自己定義

8. 客戶端配置如下所示

V2ray

```
地址：xxx-xxx.prod-glb.koyeb.app 或 CF優選IP
端口：443
默認UUID：24b4b1e1-7a89-45f6-858c-242cf53b5bdb
vmess額外id：0
加密：none
傳輸協議：ws
僞裝類型：none
僞裝域名：xxx-xxx.prod-glb.koyeb.app
路徑：/24b4b1e1-7a89-45f6-858c-242cf53b5bdb-vless
vless使用(/自定義UUID碼-vless)，vmess使用(/自定義UUID碼-vmess)
底層傳輸安全：tls
跳過證書驗證：false
```

Trojan-go

```bash
{
    "run_type": "client",
    "local_addr": "127.0.0.1",
    "local_port": 1080,
    "remote_addr": "xxx-xxx.prod-glb.koyeb.app",
    "remote_port": 443,
    "password": [
        "24b4b1e1-7a89-45f6-858c-242cf53b5bdb"
    ],
    "websocket": {
        "enabled": true,
        "path": "/24b4b1e1-7a89-45f6-858c-242cf53b5bdb-trojan",
        "host": "xxx-xxx.prod-glb.koyeb.app"
    }
}
```

ShadowSocks

```bash
服務器地址: xxx-xxx.koyeb.app
端口: 443
密碼：24b4b1e1-7a89-45f6-858c-242cf53b5bdb
加密：chacha20-ietf-poly1305
插件程序：xray-plugin_windows_amd64.exe
說明：需將插件 https://github.com/shadowsocks/xray-plugin/releases 下載解壓後放至shadowsocks同目錄
插件選項: tls;host=xxx-xxx.prod-glb.koyeb.app;path=/24b4b1e1-7a89-45f6-858c-242cf53b5bdb-ss
```

## 注意

請勿濫用本倉庫

## 贊助我們

![afdian-MisakaNo.jpg](https://s2.loli.net/2021/12/25/SimocqwhVg89NQJ.jpg)

## 交流羣
[Telegram](https://t.me/misakanetcn)
