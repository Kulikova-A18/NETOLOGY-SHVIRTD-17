# Домашнее задание к занятию 7 «Жизненный цикл ПО»

Был взят atlassian/jira-software с https://hub.docker.com/r/atlassian/jira-software/#

а также установим pgsql командой

```
vboxuser@xubu:~$ sudo -i docker run -d   --name jira-postgres   -e POSTGRES_DB=jiradb   -e POSTGRES_USER=jirauser   -e POSTGRES_PASSWORD=Russia123-  -p 5432:5432   postgres:13

Unable to find image 'postgres:13' locally
13: Pulling from library/postgres
dad67da3f26b: Pull complete 
354b408f1ffe: Pull complete 
0cc1af2d6f31: Pull complete 
25eb195b2170: Pull complete 
4e204015e10c: Pull complete 
2c7c6491a802: Pull complete 
d9f01f25a3fa: Pull complete 
b24008789900: Pull complete 
2005b83b21e7: Pull complete 
232eedc21bf6: Pull complete 
7ac5b010ec2a: Pull complete 
5134a3246f35: Pull complete 
ed941eed5ed5: Pull complete 
10cfa9828407: Pull complete 
Digest: sha256:e1195666dc3edf6c8447bea6df9d7bccfdda66ab927d1f68b1b6e0cc2262c232
Status: Downloaded newer image for postgres:13
747a2493c2ba490523f24b5cde282f4314642f8f5874538e3f5836015acce565
```

сам запуск

```
vboxuser@xubu:~$ sudo docker volume create --name jiraVolume
jiraVolume
vboxuser@xubu:~$ sudo docker run -v jiraVolume:/var/atlassian/application-data/jira --name="jira" -d -p 8080:8080 atlassian/jira-software
Unable to find image 'atlassian/jira-software:latest' locally
latest: Pulling from atlassian/jira-software
d9d352c11bbd: Pull complete 
7bbafedfaf52: Pull complete 
b61b7669ae30: Pull complete 
c70eff9bffbb: Pull complete 
d9815e77b54f: Pull complete 
0b30e44dc160: Pull complete 
16e4458a58e9: Pull complete 
aeca89b39bae: Pull complete 
1f750ecc4494: Pull complete 
d8789470623b: Pull complete 
bda75a26861d: Pull complete 
Digest: sha256:f807c7559fc611c4397564096f548a13d570c080b2252d2eea5c4282c5d88164
Status: Downloaded newer image for atlassian/jira-software:latest
9c25429ebc991327ea58b773bb177a67eaac34d13f4f61009cd497ab7aaafbfc
```

получаем информацию для подключения

```
vboxuser@xubu:~$ sudo docker ps -a
CONTAINER ID   IMAGE                     COMMAND                  CREATED         STATUS         PORTS                                         NAMES
5ce736be1f27   atlassian/jira-software   "/usr/bin/tini -- /e…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp, [::]:8080->8080/tcp   jira
b6e6770875ee   postgres:13               "docker-entrypoint.s…"   3 minutes ago   Up 3 minutes   0.0.0.0:5432->5432/tcp, [::]:5432->5432/tcp   jira-postgres
vboxuser@xubu:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:0e:33:de brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic noprefixroute enp0s3
       valid_lft 86104sec preferred_lft 86104sec
    inet6 fd17:625c:f037:2:f9a3:755a:b40a:7fa6/64 scope global temporary dynamic 
       valid_lft 85929sec preferred_lft 13929sec
    inet6 fd17:625c:f037:2:85ab:b9ea:c2cd:54fb/64 scope global dynamic mngtmpaddr noprefixroute 
       valid_lft 85929sec preferred_lft 13929sec
    inet6 fe80::21d0:2124:76a1:4bae/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 22:c6:d2:ec:a0:68 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::20c6:d2ff:feec:a068/64 scope link 
       valid_lft forever preferred_lft forever
4: veth7499f24@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether ea:86:ca:79:4d:c4 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::e886:caff:fe79:4dc4/64 scope link 
       valid_lft forever preferred_lft forever
5: veth04a3ad1@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether 0a:2f:4e:5f:c8:f2 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::82f:4eff:fe5f:c8f2/64 scope link 
       valid_lft forever preferred_lft forever
```

![image](https://github.com/user-attachments/assets/3efee0d1-5129-4f4d-a2c4-48216bcaefad)

схемы:

-  bug_workflow.xml : https://github.com/Kulikova-A18/NETOLOGY-SHVIRTD-17/blob/main/09-ci-01-intro%20/bug_workflow.xml
-  simple_workflow.xmlЖ : https://github.com/Kulikova-A18/NETOLOGY-SHVIRTD-17/blob/main/09-ci-01-intro%20/simple_workflow.xml
