# 安装socat
apt -y install socat

# 安装脚本
wget -qO- get.acme.sh | bash

# 使脚本在~/.bashrc文件追加的一行环境变量（别名）生效
source ~/.bashrc

# 将letsencrypt设置为默认CA
acme.sh --set-default-ca --server letsencrypt

# 执行下面命令前请保证vps 80端口没有被占用，且当前用户可监听（本文root默认支持）
acme.sh --issue -d example.com --standalone -k ec-256

# 创建目录
mkdir /root/dockerconf

# 分别创建caddy和trojan-go目录
cd /root/dockerconf
mkdir caddy && mkdir trojan-go

# 切换路径
cd /root/dockerconf/caddy

# 在此目录下创建配置文件，取名Caddyfile，配置文件示例如下
example.com:80 {
    gzip
    log /etc/caddy/caddy.log
    proxy / http://bing.com
}

--------------------
# 创建caddy.log空文件，否则docker容器创建时会启动失败
touch caddy.log

# 切换路径
cd /root/dockerconf/trojan-go

# 安装证书
acme.sh --installcert -d example.com --fullchain-file ./trojan.crt --key-file ./trojan.key --ecc

# 创建配置文件
vim config.json

# 下面是配置文件示例
{
        "run_type":"server",
        "local_addr":"0.0.0.0",
        "local_port":443,
        "remote_addr":"example.com",
        "remote_port":80,
        "password":[
                "password0"
        ],
        "ssl":{
                "cert":"/etc/trojan-go/trojan.crt",
                "key":"/etc/trojan-go/trojan.key",
                "sni":"example.com",
                "fallback_addr":"example.com",
                "fallback_port":80
        },
        "websocket":{
                "enabled":true,
                "path":"/trojan_path",
                "host":"example.com"
        }
}

# 切换路径
cd /root/dockerconf

# 创建配置文件
vim docker-compose.yml

# 下面是配置文件示例
version: "3"
services:
        caddy:
                image: teddysun/caddy
                container_name: caddy
                restart: always
                network_mode: "host"
                volumes:
                        - ./caddy:/etc/caddy
        trojan-go:
                image: teddysun/trojan-go
                container_name: trojan-go
                restart: always
                network_mode: "host"
                volumes:
                        - ./trojan-go:/etc/trojan-go

# 保证你切换到docker-compose.yml所在路径下
cd /root/dockerconf

# 一键启动
docker-compose up -d

# 查看logs
docker-compose logs

# 停止并移除（两个）容器组
docker-compose down