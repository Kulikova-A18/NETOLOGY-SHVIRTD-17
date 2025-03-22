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
