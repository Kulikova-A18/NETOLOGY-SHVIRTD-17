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
