#!/bin/bash
# Useage : install subtask and new RI 
# Author : agent.zy@aliyun.com 
# Copy   : Sumavision Inc.
NEW_RI_WORKSPACE=/home/admin
OS_VERSION=`awk '{print(substr($4,1,1))}' /etc/redhat-release`
NEW_RI_DIST=/usr/local/openresty

echo "[Welcome to Use SubTask Componet]";
echo "[Version 1.0]";
echo "[Sumavision]";

echo -n "[info] could you mean loadavg system will be install? (y/n)" 
read subtask_type;
if [ "$subtask_type" == "y" ]; then
	echo "[info] subtask loadavg system install begin." 
	cp -f loadavg.conf openresty/nginx/conf/nginx.conf 
	echo 'return { [type] = "loadavg" }' > suma_system_type.lua
else
	echo "[info] subtask webservice install begin."
	cp -f webservice.conf openresty/nginx/conf/nginx.conf
	echo 'return { [type] = "webservice" }' > suma_system_type.lua
fi

[ -f ./suma_system_type.lua ] && mv ./suma_system_type.lua /home/admin/lua || echo "==="

#### CHECK PATCH PACKAGE
if [ "$OS_VERSION" == "7" ] ; then
	echo "[info] version centos $OS_VERSION: is support."
else
	echo "[info] version centos $OS_VERSION: is not support."
	exit 1
fi

echo "[info] openssl and pcre deps install"
cp -rf ./deps/* /lib64/

#### CREATE LINK AND DIR
echo "[info] new RI workspace is create."
[ ! -d $NEW_RI_WORKSPACE/logs ] && mkdir -p $NEW_RI_WORKSPACE/logs || echo "[info] $NEW_RI_WORKSPACE/logs dir exists [ok]."
[ ! -d $NEW_RI_WORKSPACE/lua  ] && mkdir -p $NEW_RI_WORKSPACE/lua  || echo "[info] $NEW_RI_WORKSPACE/lua  dir exists [ok]."
[ ! -d $NEW_RI_WORKSPACE/java ] && mkdir -p $NEW_RI_WORKSPACE/java || echo "[info] $NEW_RI_WORKSPACE/java dir exists [ok]."
[ ! -d $NEW_RI_WORKSPACE/tml  ] && mkdir -p $NEW_RI_WORKSPACE/tml  || echo "[info] $NEW_RI_WORKSPACE/tml  dir exists [ok]."
[ ! -d $NEW_RI_WORKSPACE/wasm ] && mkdir -p $NEW_RI_WORKSPACE/wasm || echo "[info] $NEW_RI_WORKSPACE/wasm dir exists [ok]."
###### local ip 

if [ ! -f /home/admin/local_ip ] ; then
	`ifconfig | grep broadcast | awk '{print($2)}' | grep -v "192.168" > /home/admin/local_ip`
fi

IP=`cat /home/admin/local_ip` 
echo "[info] subtask node ip is $IP "

# ulimit Opt
cp -f limits.conf /etc/security/

#### NGINX AND LUAJIT 
echo "[info] nginx and luajit and cjson is install"
mkdir -p $NEW_RI_DIST/
mkdir -p /data/
cp -rf openresty/* $NEW_RI_DIST/
chmod 755 -R $NEW_RI_DIST

#### RUN NEW RI
echo "[info] nginx is run and request test" 
`ps -ef | grep "nginx: master" | grep -v grep | awk '{print($2)}'| xargs -r kill -15`

cp  -f subtask.conf lua/suma_ri_config.lua
cp -rf data/* /data
cp -rf lua/* $NEW_RI_WORKSPACE/lua

sleep 1
if [ -f /usr/local/openresty/nginx/logs/nginx.pid ]; then
	$NEW_RI_DIST/nginx/sbin/nginx -s stop
fi
$NEW_RI_DIST/nginx/sbin/nginx 
#### RUN BASE COMPONET
echo "[info] base commponet is run"
cp -rf java/* $NEW_RI_WORKSPACE/java
`ps -ef | grep java | grep 9801 | awk '{print($2)}' | xargs -r kill -15`
sleep 1

nohup java -server -jar  $NEW_RI_WORKSPACE/java/base-compnent-1.0.jar --server.port=9801 >/dev/null 2>&1 &

chmod 755  base_com.service
chmod 755  nginx.service
chmod 755  /home/admin/java/start.sh
cp -rf *.service /usr/lib/systemd/system

chmod 755 /usr/lib/systemd/system/base_com.service
chmod 755 /usr/lib/systemd/system/nginx.service


systemctl enable nginx.service 
systemctl enable base_com.service
systemctl disable firewalld.service
service firewalld stop

##########

curl http://127.0.0.1:10082/ -Is
sleep 3
###SERVICE CHECK
curl http://127.0.0.1:8091/ -Is | grep suma_nri > /dev/null
if [ "$?" == "0" ] ; then
	echo "[info] subtask node port  = 8091 is [ok]."
else
	echo "[info] subtask node port  = 8091 is [failed]."
	exit 1
fi

###LOCAL IP CHECK
LOCAL_IP=`curl -s http://127.0.0.1:10082/2020/v1/suma_native/local_ip.mxml`
if  [ "$?" == "0"  ]; then
	echo "[info] subtask node ip    = $LOCAL_IP is [ok]."
else
	echo "[info] subtask node ip    = Undefined is [failed]."
	echo $LOCAL_IP
	exit 1
fi

####ULIMIT CHECK
ULIMIT=`ulimit -n`
if  [ "$ULIMIT" ]; then
	echo "[info] subtask node limit = $ULIMIT is [ok]."
else
	echo "[info] subtask node limit = $ULIMIT is [failed]."
	exit 1
fi
echo "[info] subtask install done."
exit 0