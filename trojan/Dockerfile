# 使用官方的 Ubuntu 20.04 作为基础镜像
FROM ubuntu:20.04

# 设置环境变量以避免交互式安装过程中的提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装必要的软件包
RUN apt-get update && \
    apt-get install -y socat wget vim docker-compose

# 安装 acme.sh
RUN wget -qO- get.acme.sh | bash

# 设置默认的 CA
RUN /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

# 创建必要的目录
RUN mkdir -p /root/dockerconf/caddy /root/dockerconf/trojan-go

# 切换到 caddy 目录
WORKDIR /root/dockerconf/caddy

# 创建 Caddyfile 和 caddy.log
RUN echo "example.com:80 {\n    gzip\n    log /etc/caddy/caddy.log\n    proxy / http://bing.com\n}" > Caddyfile && \
    touch caddy.log

# 切换到 trojan-go 目录
WORKDIR /root/dockerconf/trojan-go

# 安装证书
RUN /root/.acme.sh/acme.sh --issue -d example.com --standalone -k ec-256 && \
    /root/.acme.sh/acme.sh --installcert -d example.com --fullchain-file ./trojan.crt --key-file ./trojan.key --ecc

# 创建 trojan-go 的配置文件
RUN echo '{\n        "run_type":"server",\n        "local_addr":"0.0.0.0",\n        "local_port":443,\n        "remote_addr":"example.com",\n        "remote_port":80,\n        "password":[\n                "password0"\n        ],\n        "ssl":{\n                "cert":"/etc/trojan-go/trojan.crt",\n                "key":"/etc/trojan-go/trojan.key",\n                "sni":"example.com",\n                "fallback_addr":"example.com",\n                "fallback_port":80\n        },\n        "websocket":{\n                "enabled":true,\n                "path":"/trojan_path",\n                "host":"example.com"\n        }\n}' > config.json

# 切换到 dockerconf 目录
WORKDIR /root/dockerconf

# 创建 docker-compose.yml 文件
RUN echo 'version: "3"\nservices:\n        caddy:\n                image: teddysun/caddy\n                container_name: caddy\n                restart: always\n                network_mode: "host"\n                volumes:\n                        - ./caddy:/etc/caddy\n        trojan-go:\n                image: teddysun/trojan-go\n                container_name: trojan-go\n                restart: always\n                network_mode: "host"\n                volumes:\n                        - ./trojan-go:/etc/trojan-go' > docker-compose.yml

# 启动服务
CMD ["docker-compose", "up", "-d"]