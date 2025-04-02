# 基于CentOS镜像
FROM centos:7.6.1810
USER root
RUN curl -fsSL https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh | bash
RUN yum install -y sudo
RUN mkdir -p /usr/local/etc/v2ray
COPY config.json /usr/local/etc/v2ray/config.json
RUN sed -i '13aEnvironment="V2RAY_VMESS_AEAD_FORCED=false"' /etc/systemd/system/v2ray.service

ENTRYPOINT ["/usr/sbin/init","&&","/usr/local/bin/v2ray","run","-config","/usr/local/etc/v2ray/config.json"]
CMD ["systemctl", "start","v2ray"]