mkdir -p ./mysql_data ./mysql_conf.d
docker-compose -f config.yml  up -d


docker exec -it mysql_server mysql -u root -p
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'rootabc123';
FLUSH PRIVILEGES;

mysql -h 127.0.0.1 -P 3306 -u root -p

centos安装mysql客户端
sudo yum install mysql
sudo yum install mysql-community-client