## Задача 3
1. Изучите файл "proxy.yaml"

```
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw/shvirtd-example-python$ cat proxy.yaml
version: '3.8'
services:

  reverse-proxy:
    image: haproxy:2.4
    restart: always
    networks:
        backend: {}
    ports:
    - "127.0.0.1:8080:8080"
    volumes:
    - ./haproxy/reverse/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:rw

  ingress-proxy:
    image: nginx:1.21.1
    restart: always
    network_mode: host
    volumes:
    - ./nginx/ingress/default.conf:/etc/nginx/conf.d/default.conf:rw
    - ./nginx/ingress/nginx.conf:/etc/nginx/nginx.conf:rw

networks:
  backend:
    driver: bridge
    ipam:
     config:
       - subnet: 172.20.0.0/24
```

Файл `proxy.yaml` является конфигурацией. 

`proxy.yaml` описывает два сервиса: 
* `reverse-proxy`
* `ingress-proxy`

1. **Версия Compose**:
```yaml
version: '3.8'
```

2. **Сервисы**:

Сервис `reverse-proxy`
   ```yaml
   reverse-proxy:
     image: haproxy:2.4
     restart: always
     networks:
         backend: {}
     ports:
     - "127.0.0.1:8080:8080"
     volumes:
     - ./haproxy/reverse/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:rw
   ```
   - **image**: Использует образ `haproxy` версии 2.4
   - **restart**: Должен автоматически перезапускаться в случае сбоя
   - **networks**: Подключает сервис к сети `backend`
   - **ports**: Пробрасывает порт 8080 контейнера на хост-машину локального интерфейса
   - **volumes**: Монтирует файл конфигурации `haproxy` из локальной файловой системы

Сервис `ingress-proxy`
   ```yaml
   ingress-proxy:
     image: nginx:1.21.1
     restart: always
     network_mode: host
     volumes:
     - ./nginx/ingress/default.conf:/etc/nginx/conf.d/default.conf:rw
     - ./nginx/ingress/nginx.conf:/etc/nginx/nginx.conf:rw
   ```
   - **image**: Использует образ `nginx` версии 1.21.1
   - **restart**: Должен автоматически перезапускаться в случае сбоя
   - **network_mode**: Устанавливает режим сети `host`, чтобы использовать сетевой стек хоста
   - **volumes**:  Монтирует файл конфигурации `nginx` из локальной файловой системы

**Сети**:
   ```yaml
   networks:
     backend:
       driver: bridge
       ipam:
        config:
          - subnet: 172.20.0.0/24
   ```
   - Определяет сеть `backend` использующую драйвер `bridge`
   - Конфигурация `ipam` задает подсеть для этой сети


2. Создайте в репозитории с проектом файл ```compose.yaml```. С помощью директивы "include" подключите к нему файл "proxy.yaml".

```
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw/shvirtd-example-python$ cat compose.yaml
version: '3.8'

# Включаем файл proxy.yaml
include:
  - proxy.yaml

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.python
    # image: cr.yandex/crphlbn0nvu5j1v4u5qo/python-app:latest
    restart: always
    networks:
      backend:
        ipv4_address: 172.20.0.5
    environment:
      - DB_HOST=db
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_NAME=${DB_NAME}

  db:
    image: mysql:8
    restart: always
    networks:
      backend:
        ipv4_address: 172.20.0.10
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}

networks:
  backend:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
```

Команды:

```
docker-compose up -d
docker ps -a
```

![image](https://github.com/user-attachments/assets/d30efc7d-fb58-4313-b983-35f9991b1639)

![image](https://github.com/user-attachments/assets/b81e0034-172d-4f8e-b9ee-c520b4eb5bdb)


3. Опишите в файле ```compose.yaml``` следующие сервисы: 

- ```web```. Образ приложения должен ИЛИ собираться при запуске compose из файла ```Dockerfile.python``` ИЛИ скачиваться из yandex cloud container registry(из задание №2 со *). Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.5```. Сервис должен всегда перезапускаться в случае ошибок.
Передайте необходимые ENV-переменные для подключения к Mysql базе данных по сетевому имени сервиса ```web``` 

- ```db```. image=mysql:8. Контейнер должен работать в bridge-сети с названием ```backend``` и иметь фиксированный ipv4-адрес ```172.20.0.10```. Явно перезапуск сервиса в случае ошибок. Передайте необходимые ENV-переменные для создания: пароля root пользователя, создания базы данных, пользователя и пароля для web-приложения.Обязательно используйте уже существующий .env file для назначения секретных ENV-переменных!

![image](https://github.com/user-attachments/assets/a0b0cd23-d224-4727-8d29-1a02109ce386)

4. Запустите проект локально с помощью docker compose , добейтесь его стабильной работы: команда ```curl -L http://127.0.0.1:8090``` должна возвращать в качестве ответа время и локальный IP-адрес. Если сервисы не стартуют воспользуйтесь командами: ```docker ps -a ``` и ```docker logs <container_name>``` . Если вместо IP-адреса вы получаете ```NULL``` --убедитесь, что вы шлете запрос на порт ```8090```, а не 5000.

![image](https://github.com/user-attachments/assets/35396794-de6d-4abb-b5a4-96e0046466db)

5. Подключитесь к БД mysql с помощью команды ```docker exec -ti <имя_контейнера> mysql -uroot -p<пароль root-пользователя>```(обратите внимание что между ключем -u и логином root нет пробела. это важно!!! тоже самое с паролем) . Введите последовательно команды (не забываем в конце символ ; ): ```show databases; use <имя вашей базы данных(по-умолчанию example)>; show tables; SELECT * from requests LIMIT 10;```.

```
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw/shvirtd-example-python$ docker exec -it 63e0855
00e 69 mysql -uroot -pYtReWq4321
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.
Commands end with ; or \g.
Your MySQL connection id is 79
Server version: 8.0.32 MySQL Community Server - GPL
Copyright (c) 2000, 2023, oracle and/or its affiliates.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql>
mysql> show databases;
|
Database
|
information_schema
|
mysql
|
performance_schema
|
sys
virtd
+-
5 rows in set (0.01 sec)
mysql> use virt;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
Database changed
mysql>
mysql> SHOW DATABASES; USE virtd; SHOW TABLES; SELECT * FROM requests LIMIT 10;
|
Database
|
|information_schema
performance_schema
virtd
|
|
3 rows in set (0.00 sec)
Database changed
|
Tables_in_virtd |
|
requests
1 row in set (0.00 sec)
|id
|
request date
||request ip
|
1 | 2025-03-22 17:26:43
|
|
|
|
|
127. 0.0.1
2 | 2025-03-22 17:26:45
127.0.0.1
3 | 2025-03-22 17:32:18
127.0.0.
4 | 2025-03-22 17:33:01
127.0.0.1
5 | 2025-03-22 17:33:03
127.0.0.1
5 rows in set (0.00 sec)
```


6. Остановите проект. В качестве ответа приложите скриншот sql-запроса.
