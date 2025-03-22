## Задача 4
1. Запустите в Yandex Cloud ВМ (вам хватит 2 Гб Ram).

![image](https://github.com/user-attachments/assets/bf5dd39f-b380-4e42-b5f8-1f1ed491d950)

3. Подключитесь к Вм по ssh и установите docker.

![image](https://github.com/user-attachments/assets/3e31f53f-5fad-4b02-b881-5cfcb5c35f29)

5. Напишите bash-скрипт, который скачает ваш fork-репозиторий в каталог /opt и запустит проект целиком.

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ nano deploy.sh
user@compute-vm-2-1-10-hdd-1742233033265:~$ chmod +x deploy.sh
user@compute-vm-2-1-10-hdd-1742233033265:~$ cat deploy.sh
#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами суперпользователя (sudo)."
  exit 1
fi

REPO_URL="https://github.com/killakazzak/shvirtd-example-python.git"
TARGET_DIR="/opt/my_project/"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Клонирование репозитория..."
  git clone "$REPO_URL" "$TARGET_DIR"
else
  echo "Репозиторий уже существует в $TARGET_DIR. Обновление..."
  cd "$TARGET_DIR" || exit
  git pull origin main
fi

cd "$TARGET_DIR" || exit

echo "Запуск проекта с помощью Docker Compose..."
docker-compose up -d

echo "Проект запущен."
```

![image](https://github.com/user-attachments/assets/5552d071-f558-42f0-98d7-18ede43bcf0a)

7. Зайдите на сайт проверки http подключений, например(или аналогичный): ```https://check-host.net/check-http``` и запустите проверку вашего сервиса ```http://<внешний_IP-адрес_вашей_ВМ>:8090```. Таким образом трафик будет направлен в ingress-proxy. ПРИМЕЧАНИЕ:  приложение main.py( в отличие от not_tested_main.py) весьма вероятно упадет под нагрузкой, но успеет обработать часть запросов - этого достаточно. Обновленная версия (main.py) не прошла достаточного тестирования временем, но должна справиться с нагрузкой.

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker ps -a
CONTAINER ID   IMAGE            COMMAND                  CREATED              STATUS              PORTS                      NAMES
fc0a7bc65526   nginx:1.21.1     "/docker-entrypoint.…"   About a minute ago   Up About a minute                              my_project-ingress-proxy-1
23fff59d81da   mysql:8          "docker-entrypoint.s…"   About a minute ago   Up About a minute   3306/tcp, 33060/tcp        my_project-db-1
835d22f0bb8f   haproxy:2.4      "docker-entrypoint.s…"   About a minute ago   Up About a minute   127.0.0.1:8080->8080/tcp   my_project-reverse-proxy-1
700cb9c2f44f   my_project-web   "python main.py"         About a minute ago   Up 13 seconds                                  my_project-web-1
user@compute-vm-2-1-10-hdd-1742233033265:~$
```

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether d0:0d:1f:2c:ee:18 brd ff:ff:ff:ff:ff:ff
    altname enp138s0
    altname ens8
    inet 10.131.0.18/24 metric 100 brd 10.131.0.255 scope global dynamic eth0
       valid_lft 4294964876sec preferred_lft 4294964876sec
    inet6 fe80::d20d:1fff:fe2c:ee18/64 scope link
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 16:2b:be:36:f4:0e brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::142b:beff:fe36:f40e/64 scope link
       valid_lft forever preferred_lft forever
5: br-dbeb263d24d8: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether d2:ca:79:13:40:ca brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global br-dbeb263d24d8
       valid_lft forever preferred_lft forever
30: br-ecdbfe77f69d: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 0a:08:8f:15:a4:8e brd ff:ff:ff:ff:ff:ff
    inet 172.20.0.1/24 brd 172.20.0.255 scope global br-ecdbfe77f69d
       valid_lft forever preferred_lft forever
    inet6 fe80::808:8fff:fe15:a48e/64 scope link
       valid_lft forever preferred_lft forever
31: vethdf45962@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-ecdbfe77f69d state UP group default
    link/ether 6e:56:87:69:36:a9 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::6c56:87ff:fe69:36a9/64 scope link
       valid_lft forever preferred_lft forever
33: veth3f17116@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-ecdbfe77f69d state UP group default
    link/ether a2:9e:0a:5b:11:4a brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::a09e:aff:fe5b:114a/64 scope link
       valid_lft forever preferred_lft forever
51: veth3362e62@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-ecdbfe77f69d state UP group default
    link/ether a2:85:a1:81:b5:52 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::a085:a1ff:fe81:b552/64 scope link
       valid_lft forever preferred_lft forever
user@compute-vm-2-1-10-hdd-1742233033265:~$ curl http://10.131.0.18:8090
TIME: 2025-03-22 15:24:53, IP: 10.131.0.18
user@compute-vm-2-1-10-hdd-1742233033265:~$ curl http://127.0.0.1:8090
TIME: 2025-03-22 15:24:57, IP: 127.0.0.1
user@compute-vm-2-1-10-hdd-1742233033265:~$
```

9. (Необязательная часть) Дополнительно настройте remote ssh context к вашему серверу. Отобразите список контекстов и результат удаленного выполнения ```docker ps -a```
10. В качестве ответа повторите  sql-запрос и приложите скриншот с данного сервера, bash-скрипт и ссылку на fork-репозиторий.

```
[root@rocky8-client shvirtd-example-python]# docker exec -it 370fc4e9084e mysql -u app -
-p
Enter password:
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.4.2 MySQL Community Server - GPL
Copyright (c) 2000, 2024, Oracle and/or its affiliates.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql>
SHOW DATABASES; USE virtd; SHOW TABLES; SELECT * FROM requests LIMIT 10;
Database
|
|
information_schema
performance_schema
virtd
|
|
3 rows in set (0.03 sec)
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
Database changed
|
Tables_in_virtd
|
requests
1 row in set (0.00 sec)
|
id
|
request_date
|
request_ip
1 | 2025-03-22 18:32:08
|
|
|
|
|
|
|
|
10.131.0.18
|
|
|
|
|
|
|
2 | 2025-03-22 18:32:09
10.131.0.18
3 | 2025-03-22 18:32:10
10.131.0.18
4 | 2025-03-22 18:32:10
10.131.0.18
5 | 2025-03-22 18:32:10
10.131.0.18
6 | 2025-03-22 18:32:10
10.131.0.18
2025-03-22 18:32:10
10.131.0.18
7 rows in set (0.00 sec)
mysql>
```

