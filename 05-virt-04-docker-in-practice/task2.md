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
