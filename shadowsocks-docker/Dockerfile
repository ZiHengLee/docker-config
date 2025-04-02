# 基于CentOS镜像
FROM centos:7.9.2009

RUN yum -y install python3 && \
    yum -y install python3-pip

RUN pip3 install shadowsocks==2.6.11


COPY docker-shadowsocks.sh /shadowsocks.sh
RUN chmod +x /shadowsocks.sh

ENTRYPOINT ["/shadowsocks.sh"]

# 启动ShadowsocksR服务
CMD ["ssserver", "-c", "/etc/shadowsocks.json"]