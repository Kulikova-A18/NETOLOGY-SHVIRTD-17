# playbook

## Необходимо установить

| Приложение | Команда установки                                        | Описание                                                  |
| ---------- | -------------------------------------------------------- | --------------------------------------------------------- |
| Nginx      | sudo apt-get install nginx                               | Устанавливает веб-сервер Nginx.                           |
| Lighthouse | npm install -g lighthouse                                | Устанавливает Lighthouse глобально через npm.             |
| Clickhouse | sudo apt-get install clickhouse-server clickhouse-client | Устанавливает сервер и клиент Clickhouse.                 |
| Vector     | curl -O <URL_TO_VECTOR_DEB><br>sudo dpkg -i <FILE_NAME>  | Загружает и устанавливает Vector из указанного источника. |

# Что делает playbook

Playbook разворачивает на заданных хостах следующие приложения:

• clickhouse-client
• clickhouse-server
• clickhouse-common
• vector
• nginx
• git
• lighthouse

## Процесс установки

1. Установка Nginx:

На отдельной виртуальной машине устанавливается и конфигурируется веб-сервер Nginx, который необходим для работы Lighthouse.

2. Установка Lighthouse:

На ту же машину скачивается Lighthouse, создается его файл web-конфигурации по указанному шаблону и перезапускается веб-сервер Nginx.

3. Установка Clickhouse:

На следующую виртуальную машину скачивается дистрибутив clickhouse-server и clickhouse-client по указанному пути с указанными именами файлов. Устанавливается clickhouse-server и clickhouse-client, создается база данных, запускается сервис Clickhouse.

4. Установка Vector:

На последнюю виртуальную машину выполняется установка дистрибутива Vector, путь к источнику установки указан в файле vars.yml. Создается сервис приложения по файлу из шаблона. После выполнения действий запускается Vector.

## Параметры

- IP адреса целевых хостов необходимо указать в файле prod.yml.
- Версии и архитектура пакетов, а также пути и остальные нужные параметры указываются в файлах vars.yml.

## Теги

• nginx
• lighthouse
• clickhouse
• vector

## Запуск

Для запуска playbook нужно выполнить команду:

```
ansible-playbook -i inventory/prod.yml site.yml
```

где inventory/prod.yml - путь к Inventory файлу, site.yml - файл playbook.
