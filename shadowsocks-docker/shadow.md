# 制作docker镜像
    docker build -t shadowssocks_env .

# 运行docker 
    宿主机端口8388放开，密码和运行的端口动态配置(默认密码88888888 端口8388)
    docker run -d -p 7890:8388 -e "PASSWORD=88888888" -e "SERVER_PORT=8388" -d shadowssocks_env

# 查看镜像是否正常运行成功
    docker ps -a
    如果运行失败:
    1.可以查看宿主机的docker日志sudo journalctl -u docker.service -n 50
    2.手动进入容器内，手动运行

# mac，window，安卓，ios下载客户端
    导入clash.yaml配置文件即可访问