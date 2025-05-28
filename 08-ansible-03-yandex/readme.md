# Домашнее задание к занятию 3 «Использование Ansible»

Выполнила Куликова Алёна Владимировна

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

# Выполнение

### пункт 1-3

Дописан еще play, который устанавливает LightHouse. 

Используются модули:

* get_url
* template
* yum
* service
* file

Происходит установка и конфигурирование веб-сервера Nginx, установка и конфигурирование LightHouse, запуск служб Nginx и LightHouse.

### пункт 4

Подготовка  inventory-файл prod.yml (смотреть https://github.com/Kulikova-A18/NETOLOGY-SHVIRTD-17/blob/main/08-ansible-03-yandex/playbook/inventory/prod.yml)

```
---
clickhouse:
  hosts:
    centos7-1:
      ansible_host: 158.160.109.207
vector:
  hosts:
    centos7-2:
      ansible_host: 158.160.102.153
lighthouse:
  hosts:
    centos7-3:
      ansible_host: 158.160.113.245
```

### пункт 5

Запущен ```ansible-lint site.yml```

Были ошибки в использовании старых наименований модулей, отсутствии прав на скачиваемые или создаваемые файлы. Ошибки исправлены.

### пункт 6

Запущен playbook с флагом ```--check```. 

Выполнение playbook завершилось с ошибкой, т.к. этот флаг не вносит изменения в системы, а выполнение playbook требует скачивания и установки пакетов приложений.

### пункт 7

Запущен playbook на prod.yml окружении с флагом ```--diff```. Изменения в систему внесены:

Фрагмент:

```
PLAY RECAP ************************************************************************************
centos 7-1    :  ok=6  changed=4   unreachable=0  failed=0  skipped=0  rescued=1  ignored=0
centos7-2     :  ok=5  changed=4   unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
centos 7-3    :  ok=11  changed=9  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
```

### пункт 8

Повторный запуск playbook с флагом ```--diff```. 

Playbook идемпотентен. 

Изменения связаны с перезапуском сервиса Vector.

Фрагмент:

```
TASK [Vector | Start service] *********************************************************************
changed: [centos7-2]

PLAY RECAP ****************************************************************************************
centos 7-1    :  ok=6  changed=4   unreachable=0  failed=0  skipped=0  rescued=1  ignored=0
centos7-2     :  ok=5  changed=4   unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
centos 7-3    :  ok=11  changed=9  unreachable=0  failed=0  skipped=0  rescued=0  ignored=0
```

### пункт 9

README.md-файл по playbook:

https://github.com/Kulikova-A18/NETOLOGY-SHVIRTD-17/blob/main/08-ansible-03-yandex/playbook/README.md


