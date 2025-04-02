# 制作docker镜像
    docker build -t v2ray_env .

# 运行docker
    宿主机端口8388放开
    docker run -p 8388:7980 --name v2ray --privileged=true -d v2ray_env

# 查看镜像是否正常运行成功
    docker ps -a
    理论上是正常运行，v2ray 5.*以上版本只能用这个命令去启动,试了各种办法，始终做不到在dockerfile里面直接完全start起来
    systemctl start v2ray
# 额外增加执行脚本
    ./start.sh 进入容器内去运行

# mac，window，安卓，ios下载客户端
    导入v2ray.yaml配置文件即可访问
    替换为你自己的服务器IP地址和域名，另外替代uuid，这个是服务端config里面配置的uuid
    服务器上uuidgen生成命令即可