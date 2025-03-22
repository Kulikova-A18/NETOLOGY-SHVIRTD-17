# Домашнее задание к занятию 5. «Практическое применение Docker»

### Инструкция к выполнению

1. Для выполнения заданий обязательно ознакомьтесь с [инструкцией](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD) по экономии облачных ресурсов. Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
3. **Своё решение к задачам оформите в вашем GitHub репозитории.**
4. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.
5. Сопроводите ответ необходимыми скриншотами.

---
## Примечание: Ознакомьтесь со схемой виртуального стенда [по ссылке](https://github.com/netology-code/shvirtd-example-python/blob/main/schema.pdf)

---

## Задача 0
1. Убедитесь что у вас НЕ(!) установлен ```docker-compose```, для этого получите следующую ошибку от команды ```docker-compose --version```
```
Command 'docker-compose' not found, but can be installed with:

sudo snap install docker          # version 24.0.5, or
sudo apt  install docker-compose  # version 1.25.0-1

See 'snap info docker' for additional versions.
```
В случае наличия установленного в системе ```docker-compose``` - удалите его.  
2. Убедитесь что у вас УСТАНОВЛЕН ```docker compose```(без тире) версии не менее v2.24.X, для это выполните команду ```docker compose version```  
###  **Своё решение к задачам оформите в вашем GitHub репозитории!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**

![image](https://github.com/user-attachments/assets/fe00a8ad-eedd-48ee-b108-86606bd5adad)

---

## Задача 1
1. Сделайте в своем github пространстве fork [репозитория](https://github.com/netology-code/shvirtd-example-python/blob/main/README.md).
   Примечание: В связи с доработкой кода python приложения. Если вы уверены что задание выполнено вами верно, а код python приложения работает с ошибкой то используйте вместо main.py файл not_tested_main.py(просто измените CMD)

* Создана директория 05-virt-04-docker-in-practice-hw для хранения всех файлов проекта
* Клонирован репозиторий с примером Python-приложения
![image](https://github.com/user-attachments/assets/abdeafde-c32d-4f00-98db-310f4906bdff)

3. Создайте файл с именем ```Dockerfile.python``` для сборки данного проекта(для 3 задания изучите https://docs.docker.com/compose/compose-file/build/ ). Используйте базовый образ ```python:3.9-slim```. 
Обязательно используйте конструкцию ```COPY . .``` в Dockerfile. Не забудьте исключить ненужные в имадже файлы с помощью dockerignore. Протестируйте корректность сборки.

* Создан файл Dockerfile.python с содержимым, необходимым для сборки Docker-образа приложения на Python:

```
cat > Dockerfile.python <<EOF
FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "main.py"]
EOF
```

* Создан файл .dockerignore, чтобы исключить ненужные файлы и директории из контекста сборки Docker

```
cat > .dockerignore <<EOF
__pycache__
*.pyc
*.pyo
.git
.gitignore
EOF
```

![image](https://github.com/user-attachments/assets/561ee510-8975-4464-8eed-93091553f9b9)

5. (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker в venv. (Mysql БД можно запустить в docker run).

* Создано виртуальное окружение для установки зависимостей

```
python3 -m venv venv
source venv/bin/activate
```

![image](https://github.com/user-attachments/assets/ee03d11d-fd9b-4803-9b0e-06f456f0e16d)

* Установлены зависимости из requirements.txt

```
pip install -r requirements.txt
```

![image](https://github.com/user-attachments/assets/ab1704ec-2e29-4477-9852-13237520c381)


* Запуск MySQL контейнера

```
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD="YtReWq4321" -e MYSQL_DATABASE="virtd" -e MYSQL_USER="app" -e MYSQL_PASSWORD="QwErTy1234" -p 3306:3306 -d mysql:latest
```

![image](https://github.com/user-attachments/assets/71e3d2b3-696a-4e3c-b72c-f2bd78792fcb)


* Выполнена команда для проверки состояния контейнеров docker ps -a

![image](https://github.com/user-attachments/assets/2d008498-b630-4963-b1bf-c118d56ca616)


6. (Необязательная часть, *) По образцу предоставленного python кода внесите в него исправление для управления названием используемой таблицы через ENV переменную.

Модифицируем файл main.py

```
from flask import Flask
from flask import request
import os
import mysql.connector
from datetime import datetime

app = Flask(__name__)
db_host=os.environ.get('DB_HOST')
db_user=os.environ.get('DB_USER')
db_password=os.environ.get('DB_PASSWORD')
db_database=os.environ.get('DB_NAME')
table_name = os.environ.get('TABLE_NAME', 'default_table_name')


# Подключение к базе данных MySQL
db = mysql.connector.connect(
host=db_host,
user=db_user,
password=db_password,
database=db_database,
autocommit=True )
cursor = db.cursor()

# SQL-запрос для создания таблицы в БД
create_table_query = f"""
CREATE TABLE IF NOT EXISTS {db_database}.{table_name} (
id INT AUTO_INCREMENT PRIMARY KEY,
request_date DATETIME,
request_ip VARCHAR(255)
)
"""
cursor.execute(create_table_query)

@app.route('/')
def index():
    # Получение IP-адреса пользователя
    ip_address = request.headers.get('X-Forwarded-For')

    # Запись в базу данных
    now = datetime.now()
    current_time = now.strftime("%Y-%m-%d %H:%M:%S")
    query = "INSERT INTO requests (request_date, request_ip) VALUES (%s, %s)"
    values = (current_time, ip_address)
    cursor.execute(query, values)
    db.commit()

    return f'TIME: {current_time}, IP: {ip_address}'


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
```

Изменяем название таблицы

```
export TABLE_NAME='new_requests'
```

---
### ВНИМАНИЕ!
!!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: ```Dockerfile.python```, ```compose.yaml```, ```.gitignore```, ```.dockerignore```,```bash-скрипт```. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!
---

---

## Задача 2 (*)
1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
2. Настройте аутентификацию вашего локального docker в yandex container registry.
3. Соберите и залейте в него образ с python приложением из задания №1.
4. Просканируйте образ на уязвимости.
5. В качестве ответа приложите отчет сканирования.

Установка yc

```
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
echo 'source /home/user/yandex-cloud/completion.zsh.inc' >>  ~/.zshrc
exec -l $SHELL
```

Токен заменен на ********************

```
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ yc init
Welcome! This command will take you through the configuration process.
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.
 Please enter OAuth token: **********************************************
You have one cloud available: 'cloud-kagamine01' (id = b1gphk6fe2qpbmph96u5). It is going to be used by default.
Please choose folder to use:
 [1] default (id = b1g2pak2mr3h8bt5nfam)
 [2] Create a new folder
Please enter your numeric choice: 1
Your current folder has been set to 'default' (id = b1g2pak2mr3h8bt5nfam).
Do you want to configure a default Compute zone? [Y/n] y
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-d
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.
```

```
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ yc container registry create --name test
done (1s)
id: crplb1fha6pb0nqgec1u
folder_id: b1g2pak2mr3h8bt5nfam
name: test
status: ACTIVE
created_at: "2025-03-22T14:55:18.479Z"

user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ yc container registry configure-docker
docker configured to use yc --profile "default" for authenticating "cr.yandex" container registries
Credential helper is configured in '/home/user/.docker/config.json'
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ sudo docker build -t cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest shvirtd-example-python/
[+] Building 83.8s (9/9) FINISHED                                                                                                      docker:default
 => [internal] load build definition from Dockerfile                                                                                             0.0s
 => => transferring dockerfile: 502B                                                                                                             0.0s
 => [internal] load metadata for docker.io/library/python:3.9-slim                                                                               1.1s
 => [internal] load .dockerignore                                                                                                                0.1s
 => => transferring context: 80B                                                                                                                 0.0s
 => [1/4] FROM docker.io/library/python:3.9-slim@sha256:e52ca5f579cc58fed41efcbb55a0ed5dccf6c7a156cba76acfb4ab42fc19dd00                         0.0s
 => [internal] load build context                                                                                                               21.2s
 => => transferring context: 115.17MB                                                                                                           21.0s
 => CACHED [2/4] WORKDIR /app                                                                                                                    0.0s
 => [3/4] COPY . .                                                                                                                              17.3s
 => [4/4] RUN pip install --no-cache-dir -r requirements.txt                                                                                    30.1s
 => exporting to image                                                                                                                          13.4s
 => => exporting layers                                                                                                                         13.3s
 => => writing image sha256:3a172c9d13efeeb8206abe9edbb78b695a2f88c895827ac05e6ddc8099f19f40                                                     0.0s
 => => naming to cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest                                                                                0.0s
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ docker push cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest
The push refers to repository [cr.yandex/crplb1fha6pb0nqgec1u/python-app]
1c62ae3154f8: Pushed
6c57db2fc2f5: Pushed
552fbae01209: Pushed
0796a33961ef: Pushed
04f6e4cfc28e: Pushed
140ec0aa8af0: Pushed
1287fbecdfcc: Pushed
latest: digest: sha256:e13cb7f7047ae66ee48dcce7870abd1ec702cd42fdcbe06e7964b5fcd2968572 size: 1789
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ yc container image list
+----------------------+---------------------+---------------------------------+--------+-----------------+
|          ID          |       CREATED       |              NAME               |  TAGS  | COMPRESSED SIZE |
+----------------------+---------------------+---------------------------------+--------+-----------------+
| crpjcdqggv44rtevrdke | 2025-03-22 15:04:45 | crplb1fha6pb0nqgec1u/python-app | latest | 120.9 MB        |
+----------------------+---------------------+---------------------------------+--------+-----------------+

user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ yc container image scan cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest
ERROR: rpc error: code = NotFound desc = Image cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest not found


server-request-id: 3ded9b7c-673b-4744-a2b1-1eeadd56d024
client-request-id: 60c63793-e245-4eb5-a64b-a0606b67e46c
server-trace-id: 789357594b961573:afcc5f56b624d19e:789357594b961573:1
client-trace-id: a82e5452-d5ce-43ac-90f5-a8667bfd7601

Use server-request-id, client-request-id, server-trace-id, client-trace-id for investigation of issues in cloud support
If you are going to ask for help of cloud support, please send the following trace file: /home/user/.config/yandex-cloud/logs/2025-03-22T15-06-38.329-yc_container_image_scan.txt
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$ cat /home/user/.config/yandex-cloud/logs/2025-03-22T15-06-38.329-yc_container_image_scan.txt
15:06:38.330188 Starting CLI    {"version": "0.145.0", "os": "linux", "arch": "amd64", "current-time": "2025-03-22 15:06:38.330157 +0000 UTC"}
15:06:38.330306 Loading config file     {"path": "/home/user/.config/yandex-cloud/config.yaml"}
15:06:38.330439 Selected profile        {"profile": "default"}
15:06:38.330563 Updating values from flags
15:06:38.354021 grpc    [core][Channel #1]Channel created
15:06:38.354094 grpc    [core][Channel #1]original dial target is: "api.cloud.yandex.net:443"
15:06:38.354118 grpc    [core][Channel #1]parsed dial target is: resolver.Target{URL:url.URL{Scheme:"api.cloud.yandex.net", Opaque:"443", User:(*url.Userinfo)(nil), Host:"", Path:"", RawPath:"", OmitHost:false, ForceQuery:false, RawQuery:"", Fragment:"", RawFragment:""}}
15:06:38.354126 grpc    [core][Channel #1]fallback to scheme "passthrough"
15:06:38.354137 grpc    [core][Channel #1]parsed dial target is: passthrough:///api.cloud.yandex.net:443
15:06:38.354145 grpc    [core][Channel #1]Channel authority set to "api.cloud.yandex.net:443"
15:06:38.354314 Update cache read       {"cache": {"check-timestamp":"2025-03-22T14:53:19Z"}}
15:06:38.354373 grpc    [core][Channel #1]Resolver state updated: {
  "Addresses": [
    {
      "Addr": "api.cloud.yandex.net:443",
      "ServerName": "",
      "Attributes": null,
      "BalancerAttributes": null,
      "Metadata": null
    }
  ],
  "Endpoints": [
    {
      "Addresses": [
        {
          "Addr": "api.cloud.yandex.net:443",
          "ServerName": "",
          "Attributes": null,
          "BalancerAttributes": null,
          "Metadata": null
        }
      ],
      "Attributes": null
    }
  ],
  "ServiceConfig": null,
  "Attributes": null
} (resolver returned new addresses)
15:06:38.354380 Update check cached.    {"last_update_check": "2025-03-22 14:53:19 +0000 UTC"}
15:06:38.354406 grpc    [core][Channel #1]Channel switches to new LB policy "pick_first"
15:06:38.354473 grpc    [core][pick-first-lb 0xc0015ef9e0] Received new config {
  "shuffleAddressList": false
}, resolver state {
  "Addresses": [
    {
      "Addr": "api.cloud.yandex.net:443",
      "ServerName": "",
      "Attributes": null,
      "BalancerAttributes": null,
      "Metadata": null
    }
  ],
  "Endpoints": [
    {
      "Addresses": [
        {
          "Addr": "api.cloud.yandex.net:443",
          "ServerName": "",
          "Attributes": null,
          "BalancerAttributes": null,
          "Metadata": null
        }
      ],
      "Attributes": null
    }
  ],
  "ServiceConfig": null,
  "Attributes": null
}
15:06:38.354495 grpc    [core][Channel #1 SubChannel #2]Subchannel created
15:06:38.354523 grpc    [core][Channel #1]Channel Connectivity change to CONNECTING
15:06:38.354560 grpc    [core][Channel #1]Channel exiting idle mode
15:06:38.354608 grpc    [core][Channel #1 SubChannel #2]Subchannel Connectivity change to CONNECTING
15:06:38.354628 grpc    [core][Channel #1 SubChannel #2]Subchannel picks a new address "api.cloud.yandex.net:443" to connect
15:06:38.354717 grpc    [core][pick-first-lb 0xc0015ef9e0] Received SubConn state update: 0xc0015efa70, {ConnectivityState:CONNECTING ConnectionError:<nil>}
15:06:38.354702 grpc    Dialing api.cloud.yandex.net:443 with timeout 19.999902138s
15:06:38.356074 grpc    Dial api.cloud.yandex.net:443 successfully connected to: 84.201.181.26:443
15:06:38.372065 grpc    [core][Channel #1 SubChannel #2]Subchannel Connectivity change to READY
15:06:38.372129 grpc    [core][pick-first-lb 0xc0015ef9e0] Received SubConn state update: 0xc0015efa70, {ConnectivityState:READY ConnectionError:<nil>}
15:06:38.372143 grpc    [core][Channel #1]Channel Connectivity change to READY
15:06:38.372198 Request  ApiEndpointService/List        {"request": {"method":"/yandex.cloud.endpoint.ApiEndpointService/List","header":{"idempotency-key":["e84e75ac-4d33-45fe-a16e-859434da805a"],"x-client-request-id":["da707969-6622-49b8-8016-df711c094a88"],"x-client-trace-id":["a82e5452-d5ce-43ac-90f5-a8667bfd7601"]},"payload":{"page_size":"100"}}}
15:06:38.383261 Response ApiEndpointService/List        {"response": {"method":"/yandex.cloud.endpoint.ApiEndpointService/List","header":{"content-type":["application/grpc"],"date":["Sat, 22 Mar 2025 15:06:38 GMT"],"server":["ycapi"],"x-request-id":["475db29f-15d6-4bf2-a028-fc89fc726d0f"],"x-server-trace-id":["b4fe7469861f0ab5:73c00646e5a5964f:b4fe7469861f0ab5:1"]},"payload":{"endpoints":[{"id":"ai-assistants","address":"assistant.api.cloud.yandex.net:443"},{"id":"ai-files","address":"assistant.api.cloud.yandex.net:443"},{"id":"ai-foundation-models","address":"llm.api.cloud.yandex.net:443"},{"id":"ai-llm","address":"llm.api.cloud.yandex.net:443"},{"id":"ai-speechkit","address":"transcribe.api.cloud.yandex.net:443"},{"id":"ai-stt","address":"transcribe.api.cloud.yandex.net:443"},{"id":"ai-stt-v3","address":"stt.api.cloud.yandex.net:443"},{"id":"ai-translate","address":"translate.api.cloud.yandex.net:443"},{"id":"ai-vision","address":"vision.api.cloud.yandex.net:443"},{"id":"ai-vision-ocr","address":"ocr.api.cloud.yandex.net:443"},{"id":"alb","address":"alb.api.cloud.yandex.net:443"},{"id":"apigateway-connections","address":"apigateway-connections.api.cloud.yandex.net:443"},{"id":"application-load-balancer","address":"alb.api.cloud.yandex.net:443"},{"id":"apploadbalancer","address":"alb.api.cloud.yandex.net:443"},{"id":"audittrails","address":"audittrails.api.cloud.yandex.net:443"},{"id":"baas","address":"backup.api.cloud.yandex.net:443"},{"id":"backup","address":"backup.api.cloud.yandex.net:443"},{"id":"billing","address":"billing.api.cloud.yandex.net:443"},{"id":"broker-data","address":"iot-data.api.cloud.yandex.net:443"},{"id":"cdn","address":"cdn.api.cloud.yandex.net:443"},{"id":"certificate-manager","address":"certificate-manager.api.cloud.yandex.net:443"},{"id":"certificate-manager-data","address":"data.certificate-manager.api.cloud.yandex.net:443"},{"id":"certificate-manager-private-ca","address":"private-ca.certificate-manager.api.cloud.yandex.net:443"},{"id":"certificate-manager-private-ca-data","address":"data.private-ca.certificate-manager.api.cloud.yandex.net:443"},{"id":"cic","address":"cic.api.cloud.yandex.net:443"},{"id":"cloud-registry","address":"registry.api.cloud.yandex.net:443"},{"id":"cloudapps","address":"cloudapps.api.cloud.yandex.net:443"},{"id":"cloudbackup","address":"backup.api.cloud.yandex.net:443"},{"id":"clouddesktops","address":"clouddesktops.api.cloud.yandex.net:443"},{"id":"cloudrouter","address":"cloudrouter.api.cloud.yandex.net:443"},{"id":"cloudvideo","address":"video.api.cloud.yandex.net:443"},{"id":"compute","address":"compute.api.cloud.yandex.net:443"},{"id":"container-registry","address":"container-registry.api.cloud.yandex.net:443"},{"id":"dataproc","address":"dataproc.api.cloud.yandex.net:443"},{"id":"dataproc-manager","address":"dataproc-manager.api.cloud.yandex.net:443"},{"id":"datasphere","address":"datasphere.api.cloud.yandex.net:443"},{"id":"datatransfer","address":"datatransfer.api.cloud.yandex.net:443"},{"id":"dns","address":"dns.api.cloud.yandex.net:443"},{"id":"endpoint","address":"api.cloud.yandex.net:443"},{"id":"fomo-dataset","address":"fomo-dataset.api.cloud.yandex.net:443"},{"id":"fomo-tuning","address":"fomo-tuning.api.cloud.yandex.net:443"},{"id":"iam","address":"iam.api.cloud.yandex.net:443"},{"id":"iot-broker","address":"iot-broker.api.cloud.yandex.net:443"},{"id":"iot-data","address":"iot-data.api.cloud.yandex.net:443"},{"id":"iot-devices","address":"iot-devices.api.cloud.yandex.net:443"},{"id":"k8s","address":"mks.api.cloud.yandex.net:443"},{"id":"kms","address":"kms.api.cloud.yandex.net:443"},{"id":"kms-crypto","address":"kms.yandex:443"},{"id":"load-balancer","address":"load-balancer.api.cloud.yandex.net:443"},{"id":"loadtesting","address":"loadtesting.api.cloud.yandex.net:443"},{"id":"locator","address":"locator.api.cloud.yandex.net:443"},{"id":"lockbox","address":"lockbox.api.cloud.yandex.net:443"},{"id":"lockbox-payload","address":"payload.lockbox.api.cloud.yandex.net:443"},{"id":"log-ingestion","address":"ingester.logging.yandexcloud.net:443"},{"id":"log-reading","address":"reader.logging.yandexcloud.net:443"},{"id":"logging","address":"logging.api.cloud.yandex.net:443"},{"id":"managed-airflow","address":"airflow.api.cloud.yandex.net:443"},{"id":"managed-clickhouse","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-elasticsearch","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-greenplum","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-kafka","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-kubernetes","address":"mks.api.cloud.yandex.net:443"},{"id":"managed-metastore","address":"metastore.api.cloud.yandex.net:443"},{"id":"managed-mongodb","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-mysql","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-opensearch","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-postgresql","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-redis","address":"mdb.api.cloud.yandex.net:443"},{"id":"managed-spark","address":"spark.api.cloud.yandex.net:443"},{"id":"managed-sqlserver","address":"mdb.api.cloud.yandex.net:443"},{"id":"marketplace","address":"marketplace.api.cloud.yandex.net:443"},{"id":"marketplace-pim","address":"marketplace.api.cloud.yandex.net:443"},{"id":"mdb-clickhouse","address":"mdb.api.cloud.yandex.net:443"},{"id":"mdb-mongodb","address":"mdb.api.cloud.yandex.net:443"},{"id":"mdb-mysql","address":"mdb.api.cloud.yandex.net:443"},{"id":"mdb-opensearch","address":"mdb.api.cloud.yandex.net:443"},{"id":"mdb-postgresql","address":"mdb.api.cloud.yandex.net:443"},{"id":"mdb-redis","address":"mdb.api.cloud.yandex.net:443"},{"id":"mdbproxy","address":"mdbproxy.api.cloud.yandex.net:443"},{"id":"monitoring","address":"monitoring.api.cloud.yandex.net:443"},{"id":"operation","address":"operation.api.cloud.yandex.net:443"},{"id":"organization-manager","address":"organization-manager.api.cloud.yandex.net:443"},{"id":"organizationmanager","address":"organization-manager.api.cloud.yandex.net:443"},{"id":"quota-manager","address":"quota-manager.api.cloud.yandex.net:443"},{"id":"quotamanager","address":"quota-manager.api.cloud.yandex.net:443"},{"id":"resource-manager","address":"resource-manager.api.cloud.yandex.net:443"},{"id":"resourcemanager","address":"resource-manager.api.cloud.yandex.net:443"},{"id":"searchapi","address":"searchapi.api.cloud.yandex.net:443"},{"id":"serialssh","address":"serialssh.cloud.yandex.net:9600"},{"id":"serverless-apigateway","address":"serverless-apigateway.api.cloud.yandex.net:443"},{"id":"serverless-containers","address":"serverless-containers.api.cloud.yandex.net:443"},{"id":"serverless-eventrouter","address":"serverless-eventrouter.api.cloud.yandex.net:443"},{"id":"serverless-functions","address":"serverless-functions.api.cloud.yandex.net:443"},{"id":"serverless-gateway-connections","address":"apigateway-connections.api.cloud.yandex.net:443"},{"id":"serverless-triggers","address":"serverless-triggers.api.cloud.yandex.net:443"},{"id":"serverless-workflows","address":"serverless-workflows.api.cloud.yandex.net:443"},{"id":"serverlesseventrouter-events","address":"events.eventrouter.serverless.yandexcloud.net:443"},{"id":"smart-captcha","address":"smartcaptcha.api.cloud.yandex.net:443"},{"id":"smart-web-security","address":"smartwebsecurity.api.cloud.yandex.net:443"},{"id":"storage","address":"storage.yandexcloud.net:443"},{"id":"storage-api","address":"storage.api.cloud.yandex.net:443"},{"id":"video","address":"video.api.cloud.yandex.net:443"},{"id":"vpc","address":"vpc.api.cloud.yandex.net:443"},{"id":"ydb","address":"ydb.api.cloud.yandex.net:443"}]}}}
15:06:38.383644 grpc    [core][Channel #4]Channel created
15:06:38.383664 grpc    [core][Channel #4]original dial target is: "container-registry.api.cloud.yandex.net:443"
15:06:38.383684 grpc    [core][Channel #4]parsed dial target is: resolver.Target{URL:url.URL{Scheme:"container-registry.api.cloud.yandex.net", Opaque:"443", User:(*url.Userinfo)(nil), Host:"", Path:"", RawPath:"", OmitHost:false, ForceQuery:false, RawQuery:"", Fragment:"", RawFragment:""}}
15:06:38.383692 grpc    [core][Channel #4]fallback to scheme "passthrough"
15:06:38.383702 grpc    [core][Channel #4]parsed dial target is: passthrough:///container-registry.api.cloud.yandex.net:443
15:06:38.383710 grpc    [core][Channel #4]Channel authority set to "container-registry.api.cloud.yandex.net:443"
15:06:38.383812 grpc    [core][Channel #4]Resolver state updated: {
  "Addresses": [
    {
      "Addr": "container-registry.api.cloud.yandex.net:443",
      "ServerName": "",
      "Attributes": null,
      "BalancerAttributes": null,
      "Metadata": null
    }
  ],
  "Endpoints": [
    {
      "Addresses": [
        {
          "Addr": "container-registry.api.cloud.yandex.net:443",
          "ServerName": "",
          "Attributes": null,
          "BalancerAttributes": null,
          "Metadata": null
        }
      ],
      "Attributes": null
    }
  ],
  "ServiceConfig": null,
  "Attributes": null
} (resolver returned new addresses)
15:06:38.383838 grpc    [core][Channel #4]Channel switches to new LB policy "pick_first"
15:06:38.383880 grpc    [core][pick-first-lb 0xc00217aae0] Received new config {
  "shuffleAddressList": false
}, resolver state {
  "Addresses": [
    {
      "Addr": "container-registry.api.cloud.yandex.net:443",
      "ServerName": "",
      "Attributes": null,
      "BalancerAttributes": null,
      "Metadata": null
    }
  ],
  "Endpoints": [
    {
      "Addresses": [
        {
          "Addr": "container-registry.api.cloud.yandex.net:443",
          "ServerName": "",
          "Attributes": null,
          "BalancerAttributes": null,
          "Metadata": null
        }
      ],
      "Attributes": null
    }
  ],
  "ServiceConfig": null,
  "Attributes": null
}
15:06:38.383897 grpc    [core][Channel #4 SubChannel #5]Subchannel created
15:06:38.383909 grpc    [core][Channel #4]Channel Connectivity change to CONNECTING
15:06:38.383929 grpc    [core][Channel #4]Channel exiting idle mode
15:06:38.383967 grpc    [core][Channel #4 SubChannel #5]Subchannel Connectivity change to CONNECTING
15:06:38.384008 grpc    [core][Channel #4 SubChannel #5]Subchannel picks a new address "container-registry.api.cloud.yandex.net:443" to connect
15:06:38.384035 grpc    Dialing container-registry.api.cloud.yandex.net:443 with timeout 19.999903287s
15:06:38.384073 grpc    [core][pick-first-lb 0xc00217aae0] Received SubConn state update: 0xc00217ab40, {ConnectivityState:CONNECTING ConnectionError:<nil>}
15:06:38.385072 grpc    Dial container-registry.api.cloud.yandex.net:443 successfully connected to: 84.201.181.26:443
15:06:38.387542 grpc    [core][Channel #4 SubChannel #5]Subchannel Connectivity change to READY
15:06:38.387580 grpc    [core][pick-first-lb 0xc00217aae0] Received SubConn state update: 0xc00217ab40, {ConnectivityState:READY ConnectionError:<nil>}
15:06:38.387593 grpc    [core][Channel #4]Channel Connectivity change to READY
15:06:38.387636 Request  ScannerService/Scan    {"request": {"method":"/yandex.cloud.containerregistry.v1.ScannerService/Scan","header":{"idempotency-key":["7041ebda-806e-41cc-979f-77ec28643757"],"x-client-request-id":["60c63793-e245-4eb5-a64b-a0606b67e46c"],"x-client-trace-id":["a82e5452-d5ce-43ac-90f5-a8667bfd7601"]},"payload":{"image_id":"cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest"}}}
15:06:38.387753 grpc    Getting IAM Token for /yandex.cloud.containerregistry.v1.ScannerService/Scan
15:06:38.387773 grpc    No IAM token cached. Creating.
15:06:38.387803 grpc    [core][Channel #7]Channel created
15:06:38.387811 grpc    [core][Channel #7]original dial target is: "iam.api.cloud.yandex.net:443"
15:06:38.387829 grpc    [core][Channel #7]parsed dial target is: resolver.Target{URL:url.URL{Scheme:"iam.api.cloud.yandex.net", Opaque:"443", User:(*url.Userinfo)(nil), Host:"", Path:"", RawPath:"", OmitHost:false, ForceQuery:false, RawQuery:"", Fragment:"", RawFragment:""}}
15:06:38.387837 grpc    [core][Channel #7]fallback to scheme "passthrough"
15:06:38.387847 grpc    [core][Channel #7]parsed dial target is: passthrough:///iam.api.cloud.yandex.net:443
15:06:38.387855 grpc    [core][Channel #7]Channel authority set to "iam.api.cloud.yandex.net:443"
15:06:38.387932 grpc    [core][Channel #7]Resolver state updated: {
  "Addresses": [
    {
      "Addr": "iam.api.cloud.yandex.net:443",
      "ServerName": "",
      "Attributes": null,
      "BalancerAttributes": null,
      "Metadata": null
    }
  ],
  "Endpoints": [
    {
      "Addresses": [
        {
          "Addr": "iam.api.cloud.yandex.net:443",
          "ServerName": "",
          "Attributes": null,
          "BalancerAttributes": null,
          "Metadata": null
        }
      ],
      "Attributes": null
    }
  ],
  "ServiceConfig": null,
  "Attributes": null
} (resolver returned new addresses)
15:06:38.387963 grpc    [core][Channel #7]Channel switches to new LB policy "pick_first"
15:06:38.387999 grpc    [core][pick-first-lb 0xc001683a70] Received new config {
  "shuffleAddressList": false
}, resolver state {
  "Addresses": [
    {
      "Addr": "iam.api.cloud.yandex.net:443",
      "ServerName": "",
      "Attributes": null,
      "BalancerAttributes": null,
      "Metadata": null
    }
  ],
  "Endpoints": [
    {
      "Addresses": [
        {
          "Addr": "iam.api.cloud.yandex.net:443",
          "ServerName": "",
          "Attributes": null,
          "BalancerAttributes": null,
          "Metadata": null
        }
      ],
      "Attributes": null
    }
  ],
  "ServiceConfig": null,
  "Attributes": null
}
15:06:38.388011 grpc    [core][Channel #7 SubChannel #8]Subchannel created
15:06:38.388022 grpc    [core][Channel #7]Channel Connectivity change to CONNECTING
15:06:38.388040 grpc    [core][Channel #7]Channel exiting idle mode
15:06:38.388071 grpc    [core][Channel #7 SubChannel #8]Subchannel Connectivity change to CONNECTING
15:06:38.388085 grpc    [core][Channel #7 SubChannel #8]Subchannel picks a new address "iam.api.cloud.yandex.net:443" to connect
15:06:38.388112 grpc    Dialing iam.api.cloud.yandex.net:443 with timeout 19.999945737s
15:06:38.388147 grpc    [core][pick-first-lb 0xc001683a70] Received SubConn state update: 0xc001683ad0, {ConnectivityState:CONNECTING ConnectionError:<nil>}
15:06:38.388963 grpc    Dial iam.api.cloud.yandex.net:443 successfully connected to: 84.201.181.26:443
15:06:38.391441 grpc    [core][Channel #7 SubChannel #8]Subchannel Connectivity change to READY
15:06:38.391474 grpc    [core][pick-first-lb 0xc001683a70] Received SubConn state update: 0xc001683ad0, {ConnectivityState:READY ConnectionError:<nil>}
15:06:38.391491 grpc    [core][Channel #7]Channel Connectivity change to READY
15:06:38.391524 Request  IamTokenService/Create {"request": {"method":"/yandex.cloud.iam.v1.IamTokenService/Create","header":{"idempotency-key":["7041ebda-806e-41cc-979f-77ec28643757"],"x-client-request-id":["4299bbf9-12d1-4fff-89d2-6fb4ca1a3016"],"x-client-trace-id":["a82e5452-d5ce-43ac-90f5-a8667bfd7601"]},"payload":{"yandex_passport_oauth_token":"*** hidden ***"}}}
15:06:38.427033 Response IamTokenService/Create {"response": {"method":"/yandex.cloud.iam.v1.IamTokenService/Create","header":{"content-type":["application/grpc"],"date":["Sat, 22 Mar 2025 15:06:38 GMT"],"server":["ycapi"],"x-request-id":["504b53f0-af03-453f-8b59-53e56b72bb1b"],"x-server-trace-id":["2bd788234e0f092d:2bbc61b4047e8bc0:2bd788234e0f092d:1"]},"payload":{"iam_token":"t1.9euelZqJx5aUkc3MypqNmcmUk5SRmu3rnpWazcqay4yUnZDKmcuKzcaVx43l8_cBXARB-e8xLmA3_t3z90EKAkH57zEuYDf-zef1656VmpKKns-ZkcuYl5GKyJyZx4vI7_zF656VmpKKns-ZkcuYl5GKyJyZx4vI.**** (F28FDF83)","expires_at":"2025-03-23T03:06:38.419948750Z"}}}
15:06:38.427167 grpc    Got IAM Token, set 'authorization' header.
15:06:38.505973 Response ScannerService/Scan    {"response": {"method":"/yandex.cloud.containerregistry.v1.ScannerService/Scan","header":{"content-type":["application/grpc"],"date":["Sat, 22 Mar 2025 15:06:38 GMT"],"server":["ycapi"],"x-request-id":["3ded9b7c-673b-4744-a2b1-1eeadd56d024"],"x-server-trace-id":["789357594b961573:afcc5f56b624d19e:789357594b961573:1"]},"trailer":{"grpc-status-details-bin":["\b\u0005\u0012@Image cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest not found\u001a\ufffd\u0001\n/type.googleapis.com/google.rpc.LocalizedMessage\u0012h\n\u0002en\u0012b{i18n:container_registry.unknownImageName,name:\"cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest\"}\u001aT\n*type.googleapis.com/google.rpc.RequestInfo\u0012&\n$3ded9b7c-673b-4744-a2b1-1eeadd56d024"]},"payload":{},"status_code":"NOT_FOUND","error":{"code":5,"message":"Image cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest not found","details":[{"@type":"type.googleapis.com/google.rpc.LocalizedMessage","locale":"en","message":"{i18n:container_registry.unknownImageName,name:\"cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest\"}"},{"@type":"type.googleapis.com/google.rpc.RequestInfo","request_id":"3ded9b7c-673b-4744-a2b1-1eeadd56d024"}]}}}
15:06:38.506534 grpc    [core][Channel #1]Channel Connectivity change to SHUTDOWN
15:06:38.506556 grpc    [core][Channel #1]Closing the name resolver
15:06:38.506576 grpc    [core][Channel #1]ccBalancerWrapper: closing
15:06:38.506620 grpc    [core][Channel #1 SubChannel #2]Subchannel Connectivity change to SHUTDOWN
15:06:38.506647 grpc    [core][Channel #1 SubChannel #2]Subchannel deleted
15:06:38.506674 grpc    [transport][client-transport 0xc000376908] Closing: rpc error: code = Canceled desc = grpc: the client connection is closing
15:06:38.506704 grpc    [transport][client-transport 0xc000376908] loopyWriter exiting with error: rpc error: code = Canceled desc = grpc: the client connection is closing
15:06:38.506877 grpc    [core][Channel #1]Channel deleted
15:06:38.506894 grpc    [core][Channel #4]Channel Connectivity change to SHUTDOWN
15:06:38.506905 grpc    [core][Channel #4]Closing the name resolver
15:06:38.506924 grpc    [core][Channel #4]ccBalancerWrapper: closing
15:06:38.506947 grpc    [core][Channel #4 SubChannel #5]Subchannel Connectivity change to SHUTDOWN
15:06:38.506961 grpc    [core][Channel #4 SubChannel #5]Subchannel deleted
15:06:38.506978 grpc    [transport][client-transport 0xc000377208] Closing: rpc error: code = Canceled desc = grpc: the client connection is closing
15:06:38.507030 grpc    [transport][client-transport 0xc000377208] loopyWriter exiting with error: rpc error: code = Canceled desc = grpc: the client connection is closing
15:06:38.507109 grpc    [core][Channel #4]Channel deleted
15:06:38.507121 grpc    [core][Channel #7]Channel Connectivity change to SHUTDOWN
15:06:38.507127 grpc    [core][Channel #7]Closing the name resolver
15:06:38.507210 grpc    [core][Channel #7]ccBalancerWrapper: closing
15:06:38.507240 grpc    [core][Channel #7 SubChannel #8]Subchannel Connectivity change to SHUTDOWN
15:06:38.507269 grpc    [core][Channel #7 SubChannel #8]Subchannel deleted
15:06:38.507286 grpc    [transport][client-transport 0xc000425b08] Closing: rpc error: code = Canceled desc = grpc: the client connection is closing
15:06:38.507312 grpc    [transport][client-transport 0xc000425b08] loopyWriter exiting with error: rpc error: code = Canceled desc = grpc: the client connection is closing
15:06:38.507431 grpc    [core][Channel #7]Channel deleted
err> ERROR: rpc error: code = NotFound desc = Image cr.yandex/crplb1fha6pb0nqgec1u/python-app:latest not found
err>
err>
err> server-request-id: 3ded9b7c-673b-4744-a2b1-1eeadd56d024
err> client-request-id: 60c63793-e245-4eb5-a64b-a0606b67e46c
err> server-trace-id: 789357594b961573:afcc5f56b624d19e:789357594b961573:1
err> client-trace-id: a82e5452-d5ce-43ac-90f5-a8667bfd7601
err>
err> Use server-request-id, client-request-id, server-trace-id, client-trace-id for investigation of issues in cloud support
err> If you are going to ask for help of cloud support, please send the following trace file: /home/user/.config/yandex-cloud/logs/2025-03-22T15-06-38.329-yc_container_image_scan.txt
user@compute-vm-2-1-10-hdd-1742233033265:~/05-virt-04-docker-in-practice-hw$
```


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

## Задача 5 (*)
1. Напишите и задеплойте на вашу облачную ВМ bash скрипт, который произведет резервное копирование БД mysql в директорию "/opt/backup" с помощью запуска в сети "backend" контейнера из образа ```schnitzler/mysqldump``` при помощи ```docker run ...``` команды. Подсказка: "документация образа."
2. Протестируйте ручной запуск
3. Настройте выполнение скрипта раз в 1 минуту через cron, crontab или systemctl timer. Придумайте способ не светить логин/пароль в git!!
4. Предоставьте скрипт, cron-task и скриншот с несколькими резервными копиями в "/opt/backup"

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ mkdir /opt/backup
user@compute-vm-2-1-10-hdd-1742233033265:~$ cat <<EOL > /opt/backup/.env
DB_USER="app"
DB_PASSWORD="QwErTy1234"
DB_NAME="virtd"
EOL
user@compute-vm-2-1-10-hdd-1742233033265:~$ cat <<EOL > backup.sh
#!/bin/bash
source /opt/backup/.env
DB_HOST="db"
BACKUP_DIR="/opt/backup"
TIMESTAMP=$(date +"%Y%m%d%H%M")
docker run --rm   --network my_project_backend   -e MYSQL_ROOT_PASSWORD="$DB_PASSWORD"   schnitzler/mysqldump   -h "$DB_HOST" -u "$DB_USER" -p"$DB_PAS
SWORD" "$DB_NAME" > "$BACKUP_DIR/backup_$TIMESTAMP.sql"
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;
EOL
```

## Задача 6
Скачайте docker образ ```hashicorp/terraform:latest``` и скопируйте бинарный файл ```/bin/terraform``` на свою локальную машину, используя dive и docker save.
Предоставьте скриншоты  действий .

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker pull hashicorp/terraform:latest
latest: Pulling from hashicorp/terraform
b0f6f1c319a1: Pull complete
bfffeba775f7: Pull complete
a5671c458144: Pull complete
80431e6a00f3: Pull complete
Digest: sha256:53222f7fc0ac1d55095cf6700b4a24496e89d4569ef60378095b470d2886be27
Status: Downloaded newer image for hashicorp/terraform:latest
docker.io/hashicorp/terraform:latest
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker save -o terraform_latest.tar hashicorp/terraform:latest
user@compute-vm-2-1-10-hdd-1742233033265:~$
```

## Задача 6.1
Добейтесь аналогичного результата, используя docker cp.  
Предоставьте скриншоты  действий .

```
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker save -o terraform_latest.tar hashicorp/terraform:latest
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker pull hashicorp/terraform:latest
latest: Pulling from hashicorp/terraform
Digest: sha256:53222f7fc0ac1d55095cf6700b4a24496e89d4569ef60378095b470d2886be27
Status: Image is up to date for hashicorp/terraform:latest
docker.io/hashicorp/terraform:latest
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker run -d --name terraform_container hashicorp/terraform:latest tail -f /dev/null
b0430f5abcb4499691ac53f48d95a746bdf378a06d2c43c7b326b1eaa8a7a8e2
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker cp terraform_container:/bin/terraform ./terraform
Successfully copied 90.6MB to /home/user/terraform
user@compute-vm-2-1-10-hdd-1742233033265:~$ docker rm -f terraform_container
terraform_container
user@compute-vm-2-1-10-hdd-1742233033265:~$ ll | grep terraform
-rwxr-xr-x 1 user user  90570904 Mar 12 11:39 terraform*
-rw------- 1 user user 118185984 Mar 22 15:53 terraform_latest.tar
user@compute-vm-2-1-10-hdd-1742233033265:~$
```

## Задача 6.2 (**)
Предложите способ извлечь файл из контейнера, используя только команду docker build и любой Dockerfile.  
Предоставьте скриншоты  действий .

## Задача 7 (***)
Запустите ваше python-приложение с помощью runC, не используя docker или containerd.  
Предоставьте скриншоты  действий .
