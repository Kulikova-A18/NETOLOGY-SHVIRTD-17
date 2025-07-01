# Домашнее задание к занятию 15 «Система сбора логов Elastic Stack»

## Дополнительные ссылки

При выполнении задания используйте дополнительные ресурсы:

- [поднимаем elk в docker](https://www.elastic.co/guide/en/elastic-stack-get-started/current/get-started-docker.html);
- [поднимаем elk в docker с filebeat и docker-логами](https://www.sarulabs.com/post/5/2019-08-12/sending-docker-logs-to-elasticsearch-and-kibana-with-filebeat.html);
- [конфигурируем logstash](https://www.elastic.co/guide/en/logstash/current/configuration.html);
- [плагины filter для logstash](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html);
- [конфигурируем filebeat](https://www.elastic.co/guide/en/beats/libbeat/5.3/config-file-format.html);
- [привязываем индексы из elastic в kibana](https://www.elastic.co/guide/en/kibana/current/index-patterns.html);
- [как просматривать логи в kibana](https://www.elastic.co/guide/en/kibana/current/discover.html);
- [решение ошибки increase vm.max_map_count elasticsearch](https://stackoverflow.com/questions/42889241/how-to-increase-vm-max-map-count).

В процессе выполнения в зависимости от системы могут также возникнуть не указанные здесь проблемы.

Используйте output stdout filebeat/kibana и api elasticsearch для изучения корня проблемы и её устранения.

## Задание повышенной сложности

Не используйте директорию [help](./help) при выполнении домашнего задания.

## Задание 1

Вам необходимо поднять в докере и связать между собой:

- elasticsearch (hot и warm ноды);
- logstash;
- kibana;
- filebeat.

Logstash следует сконфигурировать для приёма по tcp json-сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](./help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения этого задания.

Результатом выполнения задания должны быть:

- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5);
- скриншот интерфейса kibana;
- docker-compose манифест (если вы не использовали директорию help);
- ваши yml-конфигурации для стека (если вы не использовали директорию help).

```
$ sudo docker ps -a
[sudo] password for alyona: 
CONTAINER ID   IMAGE                    COMMAND                  CREATED       STATUS             PORTS                                                                                            NAMES
3e7b82458050   elastic/filebeat:8.7.0   "/usr/bin/tini -- /u…"   2 hours ago   Up About an hour                                                                                                    filebeat
bcdb8b188426   kibana:8.7.0             "/bin/tini -- /usr/l…"   2 hours ago   Up About an hour   0.0.0.0:5601->5601/tcp, :::5601->5601/tcp                                                        kibana
5606f9b35cc8   logstash:8.7.0           "/usr/local/bin/dock…"   2 hours ago   Up About an hour   0.0.0.0:5044->5044/tcp, :::5044->5044/tcp, 0.0.0.0:5046->5046/tcp, :::5046->5046/tcp, 9600/tcp   logstash
0b48b4455061   elasticsearch:8.7.0      "/bin/tini -- /usr/l…"   2 hours ago   Up About an hour   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 9300/tcp                                              es-hot
051f07c0923a   elasticsearch:8.7.0      "/bin/tini -- /usr/l…"   2 hours ago   Up About an hour   9200/tcp, 9300/tcp                                                                               051f07c0923a_es-warm
48eeb88405b1   python:3.9-alpine        "python3 /opt/run.py"    2 hours ago   Up About an hour   
```

![image](https://github.com/user-attachments/assets/cc05e13e-1c37-4e9a-8b9b-d95218ef7bff)

## Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create) и создайте несколько index-patterns из имеющихся.

![image](https://github.com/user-attachments/assets/613d0363-a5de-4fdb-9ec4-bdd77a657949)

![image](https://github.com/user-attachments/assets/410da829-e671-4619-bd23-56fbde99a69d)

Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите, как отображаются логи и как производить поиск по логам.

![image](https://github.com/user-attachments/assets/4b089c41-b425-4cc6-ac34-a9d428da1e5e)

В манифесте директории help также приведенно dummy-приложение, которое генерирует рандомные события в stdout-контейнера.
Эти логи должны порождать индекс logstash-* в elasticsearch. Если этого индекса нет — воспользуйтесь советами и источниками из раздела «Дополнительные ссылки» этого задания.

![image](https://github.com/user-attachments/assets/9ffc887f-7b9b-4411-bc50-1a141e80ab31)
 


 
