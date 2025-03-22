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

