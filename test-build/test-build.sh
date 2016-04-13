#!/bin/sh
cd ${WORKSPACE}/src
# WORKSPACE环境变量为/var/jenkins_home/jobs/CITEST/workspace
docker build -t 120.76.41.28:5000/admin/python-redis-demo:${BUILD_NUMBER} .
#根据BUILD_NUMBER的变化创建一个新的容器镜像。

docker push 120.76.41.28:5000/admin/python-redis-demo:${BUILD_NUMBER}
#将容器镜像上传到Registry服务器上并重新命名。
cd ${WORKSPACE}/test-build

sed -i 's/\$\$BUILD_NUMBER\$\$/'${BUILD_NUMBER}'/g' docker-compose.yml
#将占位符替换为变量$BUILD_NUMBER。
sed -i 's/\$\$PORT_NUMBER\$\$/'`expr 5000 + ${BUILD_NUMBER}`'/g' docker-compose.yml
#将占位符赋值为5000，替换为5000加上变量BUILD_NUMBER的值。
chmod 777 ./rancher-compose

./rancher-compose --access-key CD57D602657DB3FBE66A --secret-key rJJYvbZyopRuTHqgBy9AhNakk1gfUHrvK4hm3CuZ -p python-redis-demo-build${BUILD_NUMBER} up -d
#运行Rancher-compose命令创建一个Stack，名称为python-redis-demo-build加变量{BUILD_NUMBER}的值。添加我们刚刚复制的access key和secret key。

