Выполнила: Куликова Алёна Владимировна
Группа: shdevops-17_shvirtd-17

# Задача 1

Сценарий выполнения задачи:

- Установите docker и docker compose plugin на свою linux рабочую станцию или ВМ.
- Если dockerhub недоступен создайте файл /etc/docker/daemon.json с содержимым: `{"registry-mirrors": ["https://mirror.gcr.io", "https://daocloud.io", "https://c.163.com/", "https://registry.docker-cn.com"]}`
- Зарегистрируйтесь и создайте публичный репозиторий с именем "custom-nginx" на https://hub.docker.com (ТОЛЬКО ЕСЛИ У ВАС ЕСТЬ ДОСТУП);
- скачайте образ nginx:1.21.1;
- Создайте Dockerfile и реализуйте в нем замену дефолтной индекс-страницы(/usr/share/nginx/html/index.html), на файл index.html с содержимым:

```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
```

- Соберите и отправьте созданный образ в свой dockerhub-репозитории c tag 1.0.0 (ТОЛЬКО ЕСЛИ ЕСТЬ ДОСТУП).
- Предоставьте ответ в виде ссылки на https://hub.docker.com/<username_repo>/custom-nginx/general .

### Решение

На https://hub.docker.com не имеется доступа.

Шаг 1. Сделана машина согласно инструкции “Супер-эконом ВМ” по ссылке: https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD

Шаг 2. Установка Docker

Выполнялись следующие команды

```
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
```

Шаг 3. Установка Docker Compose

Выполнялись следующие команды

```
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ sudo curl -L " https://github.com/docker/compose/releases/latest/download/doc
ker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
% Total
% Received % Xferd Average Speed Time Time
Time Current
Dload Upload Total Spent Left Speed
e
- -
100 71.4M
100 71.4M
51.2M
0 0:00:01 0:00:01
114M
user@compute-vm-2-1-10-hdd-1742233033265:~$ sudo chmod +x /usr/local/bin/docker-compose
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker-compose --version
Docker Compose version v2.34.0
```

Шаг 4. Скачивание образа nginx:1.21.1

Выполнялись следующие команды

```
sudo docker pull nginx:1.21.1
```

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ sudo docker pull nginx:1.21.1
1.21.1: Pulling from library/nginx
a330b6cecb98: Pull complete
5ef80e6f29b5: Pull complete
f699b0db74e3: Pull complete
0f701a34c55e: Pull complete
3229dce7b89c: Pull complete
ddb78cb2d047: Pull complete
Digest: sha256:a05b0cdd4fc1be3b224ba9662ebdf98fe44c09c0c9215b45f84344c12867002e
Status: Downloaded newer image for nginx:1.21.1
docker.io/library/nginx:1.21.1
```

Шаг 5. Создание Dockerfile

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ mkdir my-nginx-project
user@compute-vm-2-1-10-hdd-1742233033265:~$ cd my-nginx-project
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ echo '<html>
>
>
>
>
>
>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
> </html>' > index.html
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ cat index.html
<html>
<head>
Hey, Netology
</head>
<body>
<<h1>I will be Devops Engineer!</h1>
</body>
</html>
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ can
<<EOF > Dockerfile
>
>
>
FROM nginx:1.21.1
COPY index.html /usr/share/nginx/html/index.html
EOF
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ can
Dockerfile
FROM nginx:1.21.1
COPY index.html /usr/share/nginx/html/index.html
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

Шаг 6. Построение и запуск контейнера

Выполнялись следующие команды

```
sudo docker build -t my-nginx .
sudo docker run -d -p 80:80 my-nginx
```

Для проверки осуществим команду

```
curl http://localhost
```

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-projects sudo docker build -t my-nginx .
[+] Building 1.2s (7/7) FINISHED
docker: default
=>
[internal] load build definition from Dockerfile
0.2s
=> => transferring dockerfile: 104B
0.0s
=> [internal] load metadata for docker.io/library/nginx:1.21.1
0.Os
=> [internal] load .dockerignore
0.1s
=>
=>
=>
=>
=>
=>
=> transferring context: 2B
0.0s
0.2s
[internal] load build context
=> transferring context: 132B
0.0s
[1/2] FROM docker.io/library/nginx:1.21.1
0.3s
[2/2] COPY index.html /usr/share/nginx/html/index.html
0.2s
exporting to image
0.1s
=> => exporting layers
0.1s
=>
=>
=> writing image sha256:685af11f1278f75bace779a1e5982fcb7f8c40405bd75d2c66b1029d344c492e
0.0s
=> naming to docker.io/library/my-nginx
0.0s
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker run -d -p 80:80 my-nginx
5a5895a8e392db464cf7952b4fe3168b42b6319fb3475621454fe23503179b5a
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ curl http://localhost
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be Dev0ps Engineer!</h1>
</body>
</html>
```

Также чтобы остановить докер Выполнялись следующие команды

```
sudo docker ps
sudo docker stop ID_CONTAINER
sudo docker rm ID_CONTAINER
```

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ curl http://localhost
curl: (7) Failed to connect to localhost port 80 after 0 ms:
Couldn't connect to server
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

# Задача 2

1. Запустите ваш образ custom-nginx:1.0.0 командой docker run в соответвии с требованиями:

- имя контейнера "ФИО-custom-nginx-t2"
- контейнер работает в фоне
- контейнер опубликован на порту хост системы 127.0.0.1:8080

2. Не удаляя, переименуйте контейнер в "custom-nginx-t2"
3. Выполните команду `date +"%d-%m-%Y %T.%N %Z" ; sleep 0.150 ; docker ps ; ss -tlpn | grep 127.0.0.1:8080  ; docker logs custom-nginx-t2 -n1 ; docker exec -it custom-nginx-t2 base64 /usr/share/nginx/html/index.html`
4. Убедитесь с помощью curl или веб браузера, что индекс-страница доступна.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение

Проверка версии с помощью следующей команды

```
sudo docker images
```

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
my-nginx     latest    685af11f1278   16 minutes ago   133MB
nginx        1.21.1    822b7ec2aaf2   3 years ago      133MB
```

Выполнялись следующие команды

```
sudo docker run --name "akulikova" -d -p 127.0.0.1:8080:80 my-nginx:latest
sudo docker rename "akulikova" "akulikova-t2"
sudo date +"%d-%m-%Y %T.%N %Z"
sudo sleep 0.150
sudo docker ps
sudo ss -tlpn | grep 127.0.0.1:8080
sudo docker logs akulikova-t2 -n1
sudo docker exec -it akulikova-t2 base64 /usr/share/nginx/html/index.html
```

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$    sudo docker run --name "akulikova" -d -p 127.0.0.1:8080:80 my-nginx:latest

62c3e7960f31975eec502475b41d54098924635971795e3bbda5c758dec0931a
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker rename "akulikova" "akulikova-t2"
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo date +"%d-%m-%Y %T.%N %Z"
17-03-2025 18:13:03.185157611 UTC
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo sleep 0.150
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                    NAMES
62c3e7960f31   my-nginx:latest   "/docker-entrypoint.…"   54 seconds ago   Up 54 seconds   127.0.0.1:8080->80/tcp   akulikova-t2
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo ss -tlpn | grep 127.0.0.1:8080
LISTEN 0      4096       127.0.0.1:8080      0.0.0.0:*    users:(("docker-proxy",pid=10796,fd=7))
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker logs akulikova-t2 -n1
2025/03/17 18:12:24 [notice] 1#1: start worker process 32
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker exec -it akulikova-t2 base64 /usr/share/nginx/html/index.html

PGh0bWw+CjxoZWFkPgpIZXksIE5ldG9sb2d5CjwvaGVhZD4KPGJvZHk+CjxoMT5JIHdpbGwgYmUg
RGV2T3BzIEVuZ2luZWVyITwvaDE+CjwvYm9keT4KPC9odG1sPgo=
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

# Задача 3

1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2".
2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.
3. Выполните `docker ps -a` и объясните своими словами почему контейнер остановился.
4. Перезапустите контейнер
5. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
6. Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
7. Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".
8. Запомните(!) и выполните команду `nginx -s reload`, а затем внутри контейнера `curl http://127.0.0.1:80 ; curl http://127.0.0.1:81`.
9. Выйдите из контейнера, набрав в консоли `exit` или Ctrl-D.
10. Проверьте вывод команд: `ss -tlpn | grep 127.0.0.1:8080` , `docker port custom-nginx-t2`, `curl http://127.0.0.1:8080`. Кратко объясните суть возникшей проблемы.
11. - Это дополнительное, необязательное задание. Попробуйте самостоятельно исправить конфигурацию контейнера, используя доступные источники в интернете. Не изменяйте конфигурацию nginx и не удаляйте контейнер. Останавливать контейнер можно. [пример источника](https://www.baeldung.com/linux/assign-port-docker-container)
12. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение

Пункт 1. Воспользуйтесь docker help или google, чтобы узнать как подключиться к стандартному потоку ввода/вывода/ошибок контейнера "custom-nginx-t2". docker attach custom-nginx-t2 docker logs custom-nginx-t2

Были выполнены следующие команды:

1. Проверка запущенных контейнеров с помощью команды sudo docker ps
1. ПЗапуск нового контейнера с помощью команды sudo docker run --name "akulikova" -d -p 127.0.0.1:8080:80 my-nginx:latest
1. Проверка статуса контейнера sudo docker ps, где получаем информацию, что контейнер успешно запущен и работает
1. Подключение к контейнеру с помощью команды sudo docker attach

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker run --name "akulikova" -d -p 127.0.0.1:8080:80 my-nginx:latest
0bc9e9a4b86a932d5e203b50ad60559f6df4f2e2810741a455faa53e25cd647f
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                    NAMES
0bc9e9a4b86a   my-nginx:latest   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds   127.0.0.1:8080->80/tcp   akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker attach akulikova
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:33 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:33 [notice] 1#1: signal 28 (SIGWINCH) received
^C2025/03/18 16:52:40 [notice] 1#1: signal 2 (SIGINT) received, exiting
2025/03/18 16:52:40 [notice] 32#32: exiting
2025/03/18 16:52:40 [notice] 31#31: exiting
2025/03/18 16:52:40 [notice] 32#32: exit
2025/03/18 16:52:40 [notice] 31#31: exit
2025/03/18 16:52:40 [notice] 1#1: signal 17 (SIGCHLD) received from 32
2025/03/18 16:52:40 [notice] 1#1: worker process 32 exited with code 0
2025/03/18 16:52:40 [notice] 1#1: signal 29 (SIGIO) received
2025/03/18 16:52:40 [notice] 1#1: signal 17 (SIGCHLD) received from 31
2025/03/18 16:52:40 [notice] 1#1: worker process 31 exited with code 0
2025/03/18 16:52:40 [notice] 1#1: exit
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

Далее были выполнены следующие команды:

1. Получение логов контейнера с помощью команды sudo docker logs akulikova
2. Анализ логов:

> Логах зафиксированы сигналы SIGWINCH и SIGINT, указывающие на изменение состояния или прерывание работы процессов "signal 2 (SIGINT) received, exiting"

> Получен сигнал прерывания, и сервер начинает завершение работы "worker process 32 exited with code 0" и "worker process 31 exited with code 0"

3. Проверка состояния контейнера с помощью команды sudo docker ps

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker logs akulikova
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/03/18 16:51:30 [notice] 1#1: using the "epoll" event method
2025/03/18 16:51:30 [notice] 1#1: nginx/1.21.1
2025/03/18 16:51:30 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6)
2025/03/18 16:51:30 [notice] 1#1: OS: Linux 6.8.0-55-generic
2025/03/18 16:51:30 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2025/03/18 16:51:30 [notice] 1#1: start worker processes
2025/03/18 16:51:30 [notice] 1#1: start worker process 31
2025/03/18 16:51:30 [notice] 1#1: start worker process 32
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:32 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:33 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:33 [notice] 1#1: signal 28 (SIGWINCH) received
2025/03/18 16:52:40 [notice] 1#1: signal 2 (SIGINT) received, exiting
2025/03/18 16:52:40 [notice] 32#32: exiting
2025/03/18 16:52:40 [notice] 31#31: exiting
2025/03/18 16:52:40 [notice] 32#32: exit
2025/03/18 16:52:40 [notice] 31#31: exit
2025/03/18 16:52:40 [notice] 1#1: signal 17 (SIGCHLD) received from 32
2025/03/18 16:52:40 [notice] 1#1: worker process 32 exited with code 0
2025/03/18 16:52:40 [notice] 1#1: signal 29 (SIGIO) received
2025/03/18 16:52:40 [notice] 1#1: signal 17 (SIGCHLD) received from 31
2025/03/18 16:52:40 [notice] 1#1: worker process 31 exited with code 0
2025/03/18 16:52:40 [notice] 1#1: exit
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

Пункт 2. Подключитесь к контейнеру и нажмите комбинацию Ctrl-C.

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps -a
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS          PORTS                    NAMES
5161ef51dfe9   my-nginx:latest   "/docker-entrypoint.…"   7 minutes ago   Up 24 seconds   127.0.0.1:8080->80/tcp   akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ ^C
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker logs akulikova
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/03/18 16:55:22 [notice] 1#1: using the "epoll" event method
2025/03/18 16:55:22 [notice] 1#1: nginx/1.21.1
2025/03/18 16:55:22 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6)
2025/03/18 16:55:22 [notice] 1#1: OS: Linux 6.8.0-55-generic
2025/03/18 16:55:22 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2025/03/18 16:55:22 [notice] 1#1: start worker processes
2025/03/18 16:55:22 [notice] 1#1: start worker process 31
2025/03/18 16:55:22 [notice] 1#1: start worker process 32
2025/03/18 17:02:06 [notice] 1#1: signal 3 (SIGQUIT) received, shutting down
2025/03/18 17:02:06 [notice] 32#32: gracefully shutting down
2025/03/18 17:02:06 [notice] 32#32: exiting
2025/03/18 17:02:06 [notice] 32#32: exit
2025/03/18 17:02:06 [notice] 31#31: gracefully shutting down
2025/03/18 17:02:06 [notice] 31#31: exiting
2025/03/18 17:02:06 [notice] 31#31: exit
2025/03/18 17:02:06 [notice] 1#1: signal 17 (SIGCHLD) received from 32
2025/03/18 17:02:06 [notice] 1#1: worker process 31 exited with code 0
2025/03/18 17:02:06 [notice] 1#1: worker process 32 exited with code 0
2025/03/18 17:02:06 [notice] 1#1: exit
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: IPv6 listen already enabled
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/03/18 17:02:07 [notice] 1#1: using the "epoll" event method
2025/03/18 17:02:07 [notice] 1#1: nginx/1.21.1
2025/03/18 17:02:07 [notice] 1#1: built by gcc 8.3.0 (Debian 8.3.0-6)
2025/03/18 17:02:07 [notice] 1#1: OS: Linux 6.8.0-55-generic
2025/03/18 17:02:07 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2025/03/18 17:02:07 [notice] 1#1: start worker processes
2025/03/18 17:02:07 [notice] 1#1: start worker process 24
2025/03/18 17:02:07 [notice] 1#1: start worker process 25
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

Пункт 3. Выполните docker ps -a и объясните своими словами почему контейнер остановился.

> Контейнер не остановился, комбинацию Ctrl-C - команда прерывания процесса (SIGINT). Команда docker stop - остановит контейнер.

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS              PORTS                    NAMES
5161ef51dfe9   my-nginx:latest   "/docker-entrypoint.…"   7 minutes ago   Up About a minute   127.0.0.1:8080->80/tcp   akulikova
```

Пункт 4. Перезапустите контейнер

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS              PORTS                    NAMES
5161ef51dfe9   my-nginx:latest   "/docker-entrypoint.…"   7 minutes ago   Up About a minute   127.0.0.1:8080->80/tcp   akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker restart akulikova
akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                    NAMES
5161ef51dfe9   my-nginx:latest   "/docker-entrypoint.…"   8 minutes ago   Up 5 seconds   127.0.0.1:8080->80/tcp   akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

Пункт 5-7. Зайдите в интерактивный терминал контейнера "custom-nginx-t2" с оболочкой bash.
Установите любимый текстовый редактор(vim, nano итд) с помощью apt-get.
Отредактируйте файл "/etc/nginx/conf.d/default.conf", заменив порт "listen 80" на "listen 81".

1. Вход был выолнен с помощью команды sudo docker exec -it akulikova /bin/bash

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker exec -it akulikova /bin/bash
root@5161ef51dfe9:/# apt update
Get:1 http://deb.debian.org/debian buster InRelease [122 kB]
Get:2 http://security.debian.org/debian-security buster/updates InRelease [34.8 kB]
Get:3 http://deb.debian.org/debian buster-updates InRelease [56.6 kB]
Get:4 http://deb.debian.org/debian buster/main amd64 Packages [7909 kB]
Get:5 http://deb.debian.org/debian buster-updates/main amd64 Packages [8788 B]
Get:6 http://security.debian.org/debian-security buster/updates/main amd64 Packages [610 kB]
Fetched 8741 kB in 2s (4006 kB/s)
Reading package lists... Done
Building dependency tree
Reading state information... Done
56 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@5161ef51dfe9:/# apt install nano
Reading package lists... Done
Building dependency tree
Reading state information... Done
Suggested packages:
  spell
The following NEW packages will be installed:
  nano
0 upgraded, 1 newly installed, 0 to remove and 56 not upgraded.
Need to get 545 kB of archives.
After this operation, 2269 kB of additional disk space will be used.
Get:1 http://security.debian.org/debian-security buster/updates/main amd64 nano amd64 3.2-3+deb10u1 [545 kB]
Fetched 545 kB in 0s (2035 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
Selecting previously unselected package nano.
(Reading database ... 7638 files and directories currently installed.)
Preparing to unpack .../nano_3.2-3+deb10u1_amd64.deb ...
Unpacking nano (3.2-3+deb10u1) ...
Setting up nano (3.2-3+deb10u1) ...
update-alternatives: using /bin/nano to provide /usr/bin/editor (editor) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/editor.1.gz because associated file /usr/share/man/man1/nano.1.gz (of link group editor) doesn't exist
update-alternatives: using /bin/nano to provide /usr/bin/pico (pico) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/pico.1.gz because associated file /usr/share/man/man1/nano.1.gz (of link group pico) doesn't exist
root@5161ef51dfe9:/#
```

2. Команда для редактирования: nano /etc/nginx/conf.d/default.conf

Содержание отредактированного /etc/nginx/conf.d/default.conf

```
server {
    listen       81;
    listen  [::]:80;
    server_name  localhost;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```

Пункт 8-9. Запомните(!) и выполните команду nginx -s reload, а затем внутри контейнера curl http://127.0.0.1:80 ; curl http://127.0.0.1:81.
image
Выйдите из контейнера, набрав в консоли exit или Ctrl-D.

Вывод с консоли

```
root@5161ef51dfe9:/# nginx -s reload
2025/03/18 17:06:12 [notice] 316#316: signal process started
root@5161ef51dfe9:/# curl http://127.0.0.1:80 ; curl http://127.0.0.1:81
curl: (7) Failed to connect to 127.0.0.1 port 80: Connection refused
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I will be DevOps Engineer!</h1>
</body>
</html>
root@5161ef51dfe9:/#
root@5161ef51dfe9:/# exit
exit
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
```

Пункт 10-11. Проверьте вывод команд: ss -tlpn | grep 127.0.0.1:8080 , docker port custom-nginx-t2, curl http://127.0.0.1:8080. Кратко объясните суть возникшей проблемы. Удалите запущенный контейнер "custom-nginx-t2", не останавливая его.(воспользуйтесь --help или google)

> ss -tlpn | grep 127.0.0.1:8080 - ss - команда, которая выводит информацию о сокетах
>
> -tlpn - это её флаги
>
> grep 127.0.0.1:8080 - фильтрует вывод
>
> вывод будет пустой, т.к. у нас нет сокетов, процессов, прослушивающих порт 8080
>
> docker port выводит список портов с которыми запускался контейнер
>
> 0.0.0.0:8080->80/tcp, :::8080->80/tcp
>
> curl http://127.0.0.1:8080 команда проверки доступности по HTTP протоколу.Отправка запроса по IP и порту. Результат - ответа нет, по данному IP и порту
>
> Суть проблемы нет доступа или недоступен ресурс по 127.0.0.1:8080 docker port - результат дал, так как при запуске был проброс портов у контейнера.

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ ss -tlpn | grep 127.0.0.1:8080
LISTEN 0      4096       127.0.0.1:8080      0.0.0.0:*
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker port akulikova
80/tcp -> 127.0.0.1:8080
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker stop akulikova
akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker rm akulikova
akulikova
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$

```

# Задача 4

- Запустите первый контейнер из образа **_centos_** c любым тегом в фоновом режиме, подключив папку текущий рабочий каталог `$(pwd)` на хостовой машине в `/data` контейнера, используя ключ -v.
- Запустите второй контейнер из образа **_debian_** в фоновом режиме, подключив текущий рабочий каталог `$(pwd)` в `/data` контейнера.
- Подключитесь к первому контейнеру с помощью `docker exec` и создайте текстовый файл любого содержания в `/data`.
- Добавьте ещё один файл в текущий каталог `$(pwd)` на хостовой машине.
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в `/data` контейнера.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод.

### Решение

Вывод с консоли

```
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
my-nginx     latest    685af11f1278   23 hours ago   133MB
nginx        1.21.1    822b7ec2aaf2   3 years ago    133MB
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo container ls -a
sudo: container: command not found
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker container ls -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker run -d -v $(pwd)/data --name centos-container --restart always centos:latest tail -f /dev/null
Unable to find image 'centos:latest' locally
docker: Error response from daemon: manifest for centos:latest not found: manifest unknown: manifest unknown

Run 'docker run --help' for more information
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker run -d -v $(pwd)/data --name centos-container --restart always my-nginx:latest tail -f /dev/null
48f23dac9215037ca83f1c045304988777a93e246465c693ba3bc2777837d673
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
my-nginx     latest    685af11f1278   23 hours ago   133MB
nginx        1.21.1    822b7ec2aaf2   3 years ago    133MB
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker container ls -a
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS     NAMES
48f23dac9215   my-nginx:latest   "/docker-entrypoint.…"   24 seconds ago   Up 23 seconds   80/tcp    centos-container
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker run -d -v $(pwd)/data --name centos-container2 --restart always my-nginx:latest tail -f /dev/null
6446cd9d34f503b106c40bccf9c15221d4fe56a1a726fa2e9eaee3d4cf85175e
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker container ls -a
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS     NAMES
6446cd9d34f5   my-nginx:latest   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds   80/tcp    centos-container2
48f23dac9215   my-nginx:latest   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   80/tcp    centos-container
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker exec -it centos-container /bin/bash
root@48f23dac9215:/# touch /data/CENTOS.txt
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ ls -l
total 8
-rw-rw-r-- 1 user user 67 Mar 17 17:53 Dockerfile
-rw-rw-r-- 1 user user 95 Mar 17 17:52 index.html
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ touch $(pwd)/CENTOS.txt
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ ls -l
total 8
-rw-rw-r-- 1 user user  0 Mar 18 17:21 CENTOS.txt
-rw-rw-r-- 1 user user 67 Mar 17 17:53 Dockerfile
-rw-rw-r-- 1 user user 95 Mar 17 17:52 index.html
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$
user@compute-vm-2-1-10-hdd-1742233033265:~/my-nginx-project$ sudo docker exec -it centos-conta
iner2 /bin/bash
root@6446cd9d34f5:/# ls -l /data
total 0
-rw-r--r-- 1 root root 0 Mar 18 17:23 CENTOS.txt
root@6446cd9d34f5:/#
```

# Задача 5

1. Создайте отдельную директорию(например /tmp/netology/docker/task5) и 2 файла внутри него.
   "compose.yaml" с содержимым:

```
version: "3"
services:
  portainer:
    network_mode: host
    image: portainer/portainer-ce:latest
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

"docker-compose.yaml" с содержимым:

```
version: "3"
services:
  registry:
    image: registry:2

    ports:
    - "5000:5000"
```

И выполните команду "docker compose up -d". Какой из файлов был запущен и почему? (подсказка: https://docs.docker.com/compose/compose-application-model/#the-compose-file )

2. Отредактируйте файл compose.yaml так, чтобы были запущенны оба файла. (подсказка: https://docs.docker.com/compose/compose-file/14-include/)

3. Выполните в консоли вашей хостовой ОС необходимые команды чтобы залить образ custom-nginx как custom-nginx:latest в запущенное вами, локальное registry. Дополнительная документация: https://distribution.github.io/distribution/about/deploying/
4. Откройте страницу "https://127.0.0.1:9000" и произведите начальную настройку portainer.(логин и пароль адмнистратора)
5. Откройте страницу "http://127.0.0.1:9000/#!/home", выберите ваше local окружение. Перейдите на вкладку "stacks" и в "web editor" задеплойте следующий компоуз:

```
version: '3'

services:
  nginx:
    image: 127.0.0.1:5000/custom-nginx
    ports:
      - "9090:80"
```

6. Перейдите на страницу "http://127.0.0.1:9000/#!/2/docker/containers", выберите контейнер с nginx и нажмите на кнопку "inspect". В представлении <> Tree разверните поле "Config" и сделайте скриншот от поля "AppArmorProfile" до "Driver".

7. Удалите любой из манифестов компоуза(например compose.yaml). Выполните команду "docker compose up -d". Прочитайте warning, объясните суть предупреждения и выполните предложенное действие. Погасите compose-проект ОДНОЙ(обязательно!!) командой.

В качестве ответа приложите скриншоты консоли, где видно все введенные команды и их вывод, файл compose.yaml , скриншот portainer c задеплоенным компоузом.

### Решение

Вывод с консоли будет в каждом из пунктов

пункт 1.

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ mkdir -p /tmp/netology/docker/task5 &&
> echo -e "version: "3"\nservices:\n  portainer:\n    image: portainer/portainer-ce:latest\n    network_mode: host\n    ports:\n      - "9000:9000"\n    volumes:\n      - /var/run/docker.sock:/var/run/docker.sock" > /tmp/netology/docker/task5/compose.yaml &&
> echo -e "version: "3"\nservices:\n  registry:\n    image: registry:2\n    network_mode: host\n    ports:\n    - "5000:5000"" > /tmp/netology/docker/task5/docker-compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:~$
user@compute-vm-2-1-10-hdd-1742233033265:~$
user@compute-vm-2-1-10-hdd-1742233033265:~$ ls /tmp/netology/docker/task5
compose.yaml  docker-compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:~$ cat /tmp/netology/docker/task5/compose.yaml
version: 3
services:
  portainer:
    image: portainer/portainer-ce:latest
    network_mode: host
    ports:
      - 9000:9000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
user@compute-vm-2-1-10-hdd-1742233033265:~$ cat /tmp/netology/docker/task5/docker-compose.yaml
version: 3
services:
  registry:
    image: registry:2
    network_mode: host
    ports:
    - 5000:5000
user@compute-vm-2-1-10-hdd-1742233033265:~$
```

Какой из файлов был запущен и почему?

> При выполнении команды docker compose up -d Docker Compose будет искать файл по умолчанию, который называется docker-compose.yaml или docker-compose.yml. Поскольку docker-compose.yaml является стандартным именем, будет запущен файл docker-compose.yaml с серверным приложением Registry.

пункт 2.

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ rm /tmp/netology/docker/task5/docker-compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:~$ rm /tmp/netology/docker/task5/compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:~$ nano /tmp/netology/docker/task5/compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:~$ cat /tmp/netology/docker/task5/compose.yaml
version: '3'
services:
  portainer:
    image: portainer/portainer-ce:latest
    network_mode: host
    ports:
      - 9000:9000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  registry:
    image: registry:2
    network_mode: host
    ports:
      - 5000:5000

user@compute-vm-2-1-10-hdd-1742233033265:~$
user@compute-vm-2-1-10-hdd-1742233033265:~$ cd /tmp/netology/docker/task5/
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ ls -l
total 4
-rw-rw-r-- 1 user user 280 Mar 19 12:14 compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ docker-compose -f compose.yaml up -d
WARN[0002] /tmp/netology/docker/task5/compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion
[+] Running 17/17
 ✔ registry Pulled                                                                                                 3.7s
   ✔ 44cf07d57ee4 Pull complete                                                                                    0.9s
   ✔ bbbdd6c6894b Pull complete                                                                                    1.1s
   ✔ 8e82f80af0de Pull complete                                                                                    1.3s
   ✔ 3493bf46cdec Pull complete                                                                                    1.3s
   ✔ 6d464ea18732 Pull complete                                                                                    1.4s
 ✔ portainer Pulled                                                                                               35.3s
   ✔ 6f4e72b360d8 Pull complete                                                                                    1.3s
   ✔ 0e898cf5aa48 Pull complete                                                                                    1.6s
   ✔ 04de093ad5ed Pull complete                                                                                   13.7s
   ✔ 86a7cce72d42 Pull complete                                                                                   15.1s
   ✔ e09df2601140 Pull complete                                                                                   20.8s
   ✔ 7969f3b791fc Pull complete                                                                                   21.0s
   ✔ 5fbe5609831b Pull complete                                                                                   26.8s
   ✔ 1ae399eb9eb9 Pull complete                                                                                   32.8s
   ✔ 6687b958fbeb Pull complete                                                                                   32.9s
   ✔ 4f4fb700ef54 Pull complete                                                                                   32.9s
[+] Running 4/4
 ✔ Container task5-registry-1                                           Started                                    5.8s
 ✔ Container task5-portainer-1                                          Started                                    5.8s
 ! registry Published ports are discarded when using host network mode                                             0.0s
 ! portainer Published ports are discarded when using host network mode                                            0.0s
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ docker container ls -a
CONTAINER ID   IMAGE                           COMMAND                  CREATED         STATUS         PORTS     NAMES
c8c9aa73889d   portainer/portainer-ce:latest   "/portainer"             4 minutes ago   Up 4 minutes             task5-portainer-1
0721d40711fb   registry:2                      "/entrypoint.sh /etc…"   4 minutes ago   Up 4 minutes             task5-registry-1
```

Пункт 3.

```
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ nano dockerfile
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ cat dockerfile
FROM nginx:latest
COPY custom-nginx-content /usr/share/nginx.html
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$
```

Пункт 4.

```
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ mkdir custom-nginx-content
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ echo "<h1>Hello, Nginx</h1>" > custom-nginx-content
/index.html
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ ls
compose.yaml  custom-nginx-content  dockerfile
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ ls -l
total 12
-rw-rw-r-- 1 user user  280 Mar 19 12:14 compose.yaml
drwxrwxr-x 2 user user 4096 Mar 19 12:41 custom-nginx-content
[+] Building 36.1s (7/7) FINISHED                                                                        docker:default
 => [internal] load build definition from dockerfile                                                               0.0s
 => => transferring dockerfile: 103B                                                                               0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                                    0.5s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 124B                                                                                  0.0s
 => [1/2] FROM docker.io/library/nginx:latest@sha256:124b44bfc9ccd1f3cedf4b592d4d1e8bddb78b51ec2ed5056c52d3692ba  28.6s
 => => resolve docker.io/library/nginx:latest@sha256:124b44bfc9ccd1f3cedf4b592d4d1e8bddb78b51ec2ed5056c52d3692bae  0.0s
 => => sha256:417c4bccf5349be7cd4ba91b1a2077ecf0ab50b3831bb071ba31f2c8bac02ed1 627B / 627B                         0.3s
 => => sha256:6e909acdb790c5a1989d9cfc795fda5a246ad6664bb27b5c688e2b734b2c5fad 28.20MB / 28.20MB                   5.6s
 => => sha256:5eaa34f5b9c2a13ef2217ceb966953dfd5c3a21a990767da307be1f57e5a1e4f 43.95MB / 43.95MB                   6.5s
 => => sha256:124b44bfc9ccd1f3cedf4b592d4d1e8bddb78b51ec2ed5056c52d3692baebc19 10.27kB / 10.27kB                   0.0s
 => => sha256:54809b2f36d0ff38e8e5362b0239779e4b75c2f19ad70ef047ed050f01506bb4 2.29kB / 2.29kB                     0.0s
 => => sha256:53a18edff8091d5faff1e42b4d885bc5f0f897873b0b8f0ace236cd5930819b0 8.58kB / 8.58kB                     0.0s
 => => sha256:e7e0ca015e553ccff5686ec2153c895313675686d3f6940144ce935c07554d85 955B / 955B                         0.7s
 => => sha256:373fe654e9845b69587105e1b82833209521db456bdc5bc26ac7260e3eb2dd52 405B / 405B                         4.8s
 => => sha256:97f5c0f51d43d499970597eef919f9170954289eff0c5d7b8f8afd73dbb57977 1.21kB / 1.21kB                     6.7s
 => => extracting sha256:6e909acdb790c5a1989d9cfc795fda5a246ad6664bb27b5c688e2b734b2c5fad                          3.9s
 => => sha256:c22eb46e871ad1cda19691450312c6b5c25eb5e6836773821d8091cffb6327cc 1.40kB / 1.40kB                     6.9s
 => => extracting sha256:5eaa34f5b9c2a13ef2217ceb966953dfd5c3a21a990767da307be1f57e5a1e4f                         11.5s
 => => extracting sha256:417c4bccf5349be7cd4ba91b1a2077ecf0ab50b3831bb071ba31f2c8bac02ed1                          0.0s
 => => extracting sha256:e7e0ca015e553ccff5686ec2153c895313675686d3f6940144ce935c07554d85                          0.0s
 => => extracting sha256:373fe654e9845b69587105e1b82833209521db456bdc5bc26ac7260e3eb2dd52                          0.0s
 => => extracting sha256:97f5c0f51d43d499970597eef919f9170954289eff0c5d7b8f8afd73dbb57977                          0.0s
 => => extracting sha256:c22eb46e871ad1cda19691450312c6b5c25eb5e6836773821d8091cffb6327cc                          0.0s
 => [2/2] COPY custom-nginx-content /usr/share/nginx.html                                                          5.8s
 => exporting to image                                                                                             0.5s
 => => exporting layers                                                                                            0.2s
 => => writing image sha256:f1396f1885e8247e196773c4317da5d8f48c83ed2dc14ddb1a0bf73ca47f9c16                       0.0s
 => => naming to docker.io/library/custom-nginx:latest                                                             0.1s
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ docker images
REPOSITORY               TAG       IMAGE ID       CREATED          SIZE
custom-nginx             latest    f1396f1885e8   30 seconds ago   192MB
portainer/portainer-ce   latest    13362f23a453   12 hours ago     268MB
my-nginx                 latest    685af11f1278   43 hours ago     133MB
registry                 2         26b2eb03618e   17 months ago    25.4MB
nginx                    1.21.1    822b7ec2aaf2   3 years ago      133MB
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ sudo docker tag custom-nginx:latest  localhost:5000/custom-nginx:latest
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ sudo docker push localhost:5000/custom-nginx:latest
The push refers to repository [localhost:5000/custom-nginx]
019998a23e59: Pushed
03d9365bc5dc: Pushed
d26dc06ef910: Pushed
aa82c57cd9fe: Pushed
d98dcc720ae0: Pushed
ad2f08e39a9d: Pushed
135f786ad046: Pushed
1287fbecdfcc: Pushed
latest: digest: sha256:92cc03fc6b8f12216b32227fc066226f8644f2b52e71f2e1340e93b705540a41 size: 1985
```

Пункт 5.

Воспользуюсь программой для работы с get/post запросами. Сама программа: “Burp Suite”

Так как получала ошибку

> Your Portainer instance has timed out for security purposes

Были выполнены следующие команды

```
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ sudo docker ps
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS          PORTS     NAMES
c8c9aa73889d   portainer/portainer-ce:latest   "/portainer"             35 minutes ago   Up 35 minutes             task5-portainer-1
0721d40711fb   registry:2                      "/entrypoint.sh /etc…"   35 minutes ago   Up 35 minutes             task5-registry-1
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ sudo docker restart c8c9aa73889d
c8c9aa73889d
```

Запрос на регистрацию администратора:

```
POST /api/users/admin/init HTTP/1.1
Host: 84.252.133.38:9000
Content-Length: 49
Accept-Language: ru-RU,ru;q=0.9
Accept: application/json, text/plain, */*
Content-Type: application/json
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36
Origin: http://84.252.133.38:9000
Referer: http://84.252.133.38:9000/
Accept-Encoding: gzip, deflate, br
Connection: keep-alive

{"Username":"admin","Password":"adminadminadmin"}
```

Пункт 6.

```
POST /api/stacks/create/standalone/string?endpointId=3 HTTP/1.1
Host: 84.252.133.38:9000
Content-Length: 196
X-CSRF-Token: 81pYgMJK075jWrYSwScYiUD+gtsgZl55ff6/fjoE1yK8VDUANF/g6mDZI8ubUIlfeB5hXnXDlKqUfO+RO3PCxg==
Accept-Language: ru-RU,ru;q=0.9
Accept: application/json, text/plain, */*
Content-Type: application/json
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36
Origin: http://84.252.133.38:9000
Referer: http://84.252.133.38:9000/
Accept-Encoding: gzip, deflate, br
Cookie: portainer_api_key=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJhZG1pbiIsInJvbGUiOjEsInNjb3BlIjoiZGVmYXVsdCIsImZvcmNlQ2hhbmdlUGFzc3dvcmQiOmZhbHNlLCJleHAiOjE3NDI0MTc3NDgsImlhdCI6MTc0MjM4ODk0OCwianRpIjoiMjI4YTkzMTktYzE3Mi00ZjBjLWEzOWEtZjlhMmJmZGFiYjkzIn0.qOUmbwL6ev-QuMpjbmIVd0VoIsfSx8UKvXGNaXED3qo; _gorilla_csrf=MTc0MjM4ODk0OHxJbFIzTlhSblVGbFdUVEZSUkdjMVdGcFhibVZTTVdwcVp6UTBWbFp3WTNKVU5sbEtVVGQzUmpOR1pWRTlJZ289fK4gSpDwVS_3eFYu0scmuQSvDg-8E_xb8IaUELRJ-IUg
Connection: keep-alive

{"method":"string","type":"standalone","Name":"deploy-1","StackFileContent":"version: '3'\n\nservices:\n  nginx:\n    image: 127.0.0.1:5000/custom-nginx\n    ports:\n      - \"9090:80\"","Env":[]}
```

Пункт 7.

По следующему пути http://84.252.133.38:9000/#!/3/docker/containers/630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42/inspect получаем дерево

```
{
    "AppArmorProfile": "docker-default",
    "Args": [
        "nginx",
        "-g",
        "daemon off;"
    ],
    "Config": {
        "AttachStderr": true,
        "AttachStdin": false,
        "AttachStdout": true,
        "Cmd": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "Domainname": "",
        "Entrypoint": [
            "/docker-entrypoint.sh"
        ],
        "Env": [
            "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
            "NGINX_VERSION=1.27.4",
            "NJS_VERSION=0.8.9",
            "NJS_RELEASE=1~bookworm",
            "PKG_RELEASE=1~bookworm",
            "DYNPKG_RELEASE=1~bookworm"
        ],
        "ExposedPorts": {
            "80/tcp": {}
        },
        "Hostname": "630bbb819ec6",
        "Image": "127.0.0.1:5000/custom-nginx",
        "Labels": {
            "com.docker.compose.config-hash": "8b9fe9ab3a7934244a4cb3d97ea83abe99d1849b88a7d7931370a021dd008c42",
            "com.docker.compose.container-number": "1",
            "com.docker.compose.depends_on": "",
            "com.docker.compose.image": "sha256:f1396f1885e8247e196773c4317da5d8f48c83ed2dc14ddb1a0bf73ca47f9c16",
            "com.docker.compose.oneoff": "False",
            "com.docker.compose.project": "deploy-1",
            "com.docker.compose.project.config_files": "",
            "com.docker.compose.project.working_dir": "/data/compose/1",
            "com.docker.compose.service": "nginx",
            "com.docker.compose.version": "",
            "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
        },
        "OnBuild": null,
        "OpenStdin": false,
        "StdinOnce": false,
        "StopSignal": "SIGQUIT",
        "Tty": false,
        "User": "",
        "Volumes": null,
        "WorkingDir": ""
    },
    "Created": "2025-03-19T13:01:40.145094638Z",
    "Driver": "overlay2",
    "ExecIDs": null,
    "GraphDriver": {
        "Data": {
            "ID": "630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42",
            "LowerDir": "/var/lib/docker/overlay2/b728f3ffbaa05cc120fb39481194588718c6ea2b39a8fab93bd452fa4398ed5b-init/diff:/var/lib/docker/overlay2/sh6e0jdv8y2565vastl60fmd9/diff:/var/lib/docker/overlay2/569d645d29f5fbf3434a0b56e9c4ed4032780e6133052c3c1ffd5e50402990a9/diff:/var/lib/docker/overlay2/177dc9c857f0ff6b0a66671cb3a87a1bb1ef55713e00abc9883e1af5f3800451/diff:/var/lib/docker/overlay2/84c91bac723e99c5da57b60b6a96c814c7e7dbbf09ed9159fa3ede8916404579/diff:/var/lib/docker/overlay2/87e7ecd6571c6b98c9c5b48aafa226daca6e067d14edd4a70be87d1ee919a195/diff:/var/lib/docker/overlay2/df08ed42bf7495cb79da8e1eac8b07e3f8a8d8fc691b6d41be39993f4e0d484b/diff:/var/lib/docker/overlay2/8ed9b50fc649d5c25fec9cd67606b23b1dbf164349a8df122de093ff65d5e373/diff:/var/lib/docker/overlay2/c77f8e125281f3a815cbf80909b28c8ba0ad09c16af5ea492caf9cc74b5b11b2/diff",
            "MergedDir": "/var/lib/docker/overlay2/b728f3ffbaa05cc120fb39481194588718c6ea2b39a8fab93bd452fa4398ed5b/merged",
            "UpperDir": "/var/lib/docker/overlay2/b728f3ffbaa05cc120fb39481194588718c6ea2b39a8fab93bd452fa4398ed5b/diff",
            "WorkDir": "/var/lib/docker/overlay2/b728f3ffbaa05cc120fb39481194588718c6ea2b39a8fab93bd452fa4398ed5b/work"
        },
        "Name": "overlay2"
    },
    "HostConfig": {
        "AutoRemove": false,
        "Binds": null,
        "BlkioDeviceReadBps": null,
        "BlkioDeviceReadIOps": null,
        "BlkioDeviceWriteBps": null,
        "BlkioDeviceWriteIOps": null,
        "BlkioWeight": 0,
        "BlkioWeightDevice": null,
        "CapAdd": null,
        "CapDrop": null,
        "Cgroup": "",
        "CgroupParent": "",
        "CgroupnsMode": "private",
        "ConsoleSize": [
            0,
            0
        ],
        "ContainerIDFile": "",
        "CpuCount": 0,
        "CpuPercent": 0,
        "CpuPeriod": 0,
        "CpuQuota": 0,
        "CpuRealtimePeriod": 0,
        "CpuRealtimeRuntime": 0,
        "CpuShares": 0,
        "CpusetCpus": "",
        "CpusetMems": "",
        "DeviceCgroupRules": null,
        "DeviceRequests": null,
        "Devices": null,
        "Dns": null,
        "DnsOptions": null,
        "DnsSearch": null,
        "ExtraHosts": [],
        "GroupAdd": null,
        "IOMaximumBandwidth": 0,
        "IOMaximumIOps": 0,
        "IpcMode": "private",
        "Isolation": "",
        "Links": null,
        "LogConfig": {
            "Config": {},
            "Type": "json-file"
        },
        "MaskedPaths": [
            "/proc/asound",
            "/proc/acpi",
            "/proc/kcore",
            "/proc/keys",
            "/proc/latency_stats",
            "/proc/timer_list",
            "/proc/timer_stats",
            "/proc/sched_debug",
            "/proc/scsi",
            "/sys/firmware",
            "/sys/devices/virtual/powercap"
        ],
        "Memory": 0,
        "MemoryReservation": 0,
        "MemorySwap": 0,
        "MemorySwappiness": null,
        "NanoCpus": 0,
        "NetworkMode": "deploy-1_default",
        "OomKillDisable": null,
        "OomScoreAdj": 0,
        "PidMode": "",
        "PidsLimit": null,
        "PortBindings": {
            "80/tcp": [
                {
                    "HostIp": "",
                    "HostPort": "9090"
                }
            ]
        },
        "Privileged": false,
        "PublishAllPorts": false,
        "ReadonlyPaths": [
            "/proc/bus",
            "/proc/fs",
            "/proc/irq",
            "/proc/sys",
            "/proc/sysrq-trigger"
        ],
        "ReadonlyRootfs": false,
        "RestartPolicy": {
            "MaximumRetryCount": 0,
            "Name": "no"
        },
        "Runtime": "runc",
        "SecurityOpt": null,
        "ShmSize": 67108864,
        "UTSMode": "",
        "Ulimits": null,
        "UsernsMode": "",
        "VolumeDriver": "",
        "VolumesFrom": null
    },
    "HostnamePath": "/var/lib/docker/containers/630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42/hostname",
    "HostsPath": "/var/lib/docker/containers/630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42/hosts",
    "Id": "630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42",
    "Image": "sha256:f1396f1885e8247e196773c4317da5d8f48c83ed2dc14ddb1a0bf73ca47f9c16",
    "LogPath": "/var/lib/docker/containers/630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42/630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42-json.log",
    "MountLabel": "",
    "Mounts": [],
    "Name": "/deploy-1-nginx-1",
    "NetworkSettings": {
        "Bridge": "",
        "EndpointID": "",
        "Gateway": "",
        "GlobalIPv6Address": "",
        "GlobalIPv6PrefixLen": 0,
        "HairpinMode": false,
        "IPAddress": "",
        "IPPrefixLen": 0,
        "IPv6Gateway": "",
        "LinkLocalIPv6Address": "",
        "LinkLocalIPv6PrefixLen": 0,
        "MacAddress": "",
        "Networks": {
            "deploy-1_default": {
                "Aliases": [
                    "deploy-1-nginx-1",
                    "nginx",
                    "630bbb819ec6"
                ],
                "DNSNames": [
                    "deploy-1-nginx-1",
                    "nginx",
                    "630bbb819ec6"
                ],
                "DriverOpts": null,
                "EndpointID": "6793ba86566625e58a1621912c096057f82bdeebb6b7ece0015826370f936ef0",
                "Gateway": "172.18.0.1",
                "GlobalIPv6Address": "",
                "GlobalIPv6PrefixLen": 0,
                "GwPriority": 0,
                "IPAMConfig": null,
                "IPAddress": "172.18.0.2",
                "IPPrefixLen": 16,
                "IPv6Gateway": "",
                "Links": null,
                "MacAddress": "4e:24:7d:51:2b:23",
                "NetworkID": "dbeb263d24d89e77aad734b6a203e9e64ff770fd8e1c1bd5695f359d4777366c"
            }
        },
        "Ports": {
            "80/tcp": [
                {
                    "HostIp": "0.0.0.0",
                    "HostPort": "9090"
                },
                {
                    "HostIp": "::",
                    "HostPort": "9090"
                }
            ]
        },
        "SandboxID": "5b7eb5b00a6fd8503890930785d09f7c3f5a2cf3c0dcf049b0b85d0ea806dfe1",
        "SandboxKey": "/var/run/docker/netns/5b7eb5b00a6f",
        "SecondaryIPAddresses": null,
        "SecondaryIPv6Addresses": null
    },
    "Path": "/docker-entrypoint.sh",
    "Platform": "linux",
    "Portainer": {
        "ResourceControl": {
            "Id": 1,
            "ResourceId": "3_deploy-1",
            "SubResourceIds": [],
            "Type": 6,
            "UserAccesses": [],
            "TeamAccesses": [],
            "Public": false,
            "AdministratorsOnly": true,
            "System": false
        }
    },
    "ProcessLabel": "",
    "ResolvConfPath": "/var/lib/docker/containers/630bbb819ec685ee31cb53d689a37f31d8e8b491763271b3f611f566d3ba5d42/resolv.conf",
    "RestartCount": 0,
    "State": {
        "Dead": false,
        "Error": "",
        "ExitCode": 0,
        "FinishedAt": "0001-01-01T00:00:00Z",
        "OOMKilled": false,
        "Paused": false,
        "Pid": 3302,
        "Restarting": false,
        "Running": true,
        "StartedAt": "2025-03-19T13:01:40.396648128Z",
        "Status": "running"
    }
}
```

Пункт 8.

```
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ ls -l
total 12
-rw-rw-r-- 1 user user  280 Mar 19 12:14 compose.yaml
drwxrwxr-x 2 user user 4096 Mar 19 12:41 custom-nginx-content
-rw-rw-r-- 1 user user   66 Mar 19 12:36 dockerfile
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ mv -f compose.yaml comproseyaml
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ ls -l
total 12
-rw-rw-r-- 1 user user  280 Mar 19 12:14 comproseyaml
drwxrwxr-x 2 user user 4096 Mar 19 12:41 custom-nginx-content
-rw-rw-r-- 1 user user   66 Mar 19 12:36 dockerfile
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ sudo docker-compose up -d
no configuration file provided: not found
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ echo -e "version: "3"\nservices:\n  registry:\n    image: registry:2\n    network_mode: host\n    ports:\n    - "5000:5000"" > /tmp/netology/docker/task5/docker-compose.yaml
user@compute-vm-2-1-10-hdd-1742233033265:/tmp/netology/docker/task5$ sudo docker-compose up -d
WARN[0000] /tmp/netology/docker/task5/docker-compose.yaml: the attribute `version` is obsolete, it will be ignored, please remove it to avoid potential confusion
WARN[0000] Found orphan containers ([task5-portainer-1]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
[+] Running 1/1
 ✔ Container task5-registry-1  Running
```

Это предупреждение сигнализирует о наличии контейнеров, созданных для сервисов, которые больше не указаны в файле docker-compose.yml. Такие контейнеры называют "осиротевшими".

Чтобы устранить это предупреждение и удалить осиротевшие контейнеры, можно использовать команду docker-compose с флагом --remove-orphans:

```
docker-compose up --remove-orphans
```

Обязательно необходимо завершить работу вашего compose-проекта с помощью единственной команды:

```
docker-compose down --remove-orphans
```
