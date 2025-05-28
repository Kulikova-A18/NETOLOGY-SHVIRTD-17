# Домашнее задание к занятию 5 «Тестирование roles»

Выполнила Куликова Алёна Владимировна

## Подготовка к выполнению

1. Установите molecule и его драйвера: `pip3 install "molecule molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` — это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

> сделано

## Основная часть

Ваша цель — настроить тестирование ваших ролей.
Задача — сделать сценарии тестирования для vector.
Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите `molecule test -s ubuntu_xenial` (или с любым другим сценарием, не имеет значения) внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками или не отработать вовсе, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу И из чего может состоять сценарий тестирования.

> сделано

Результат в консоли:

```
molecule test -s centos_7
---
dependency:
  name: galaxy
driver:
  name: docker
  options:
    D: true
    vv: true
lint: 'yamllint .

  ansible-lint

  flake8

  '
platforms:
  - capabilities:
      - SYS_ADMIN
    command: /usr/sbin/init
    dockerfile: ../resources/Dockerfile.j2
    env:
      ANSIBLE_USER: ansible
      DEPLOY_GROUP: deployer
      SUDO_GROUP: wheel
      container: docker
    image: centos:7
    name: centos_7
    privileged: true
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
provisioner:
  inventory:
    links:
      group_vars: ../resources/inventory/group_vars/
      host_vars: ../resources/inventory/host_vars/
      hosts: ../resources/inventory/hosts.yml
  name: ansible
  options:
    D: true
    vv: true
  playbooks:
    converge: ../resources/playbooks/converge.yml
verifier:
  name: ansible
  playbooks:
    verify: ../resources/tests/verify.yml

CRITICAL Failed to pre-validate.

{'driver': [{'name': ['unallowed value docker']}]}
```

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

> сделано

Результат в консоли ```molecule init scenario --driver-name docker```

```
Usage: molecule init scenario [OPTIONS] [SCENARIO_NAME]
Try 'molecule init scenario --help' for help.

Error: Invalid value for '--driver-name' / '-d': 'docker' is not 'delegated'.
```

Так как команда molecule init scenario не принимает значение docker для параметра --driver-name, доустанавливем с помощью следующей команды:

```
pip install molecule-docker
```

повторный запуск ```molecule init scenario --driver-name docker```

```
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/alvona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector-role/molecule/default successfully.
```


3. Добавьте несколько разных дистрибутивов (oraclelinux:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

> сделано

Добавлена информация о нескольких дистрибутивах в файл molecule.yml (смотреть vector_role/molecule/default/molecule.yml)

```
---
dependency:
  name: galaxy
driver:
  name: podman
platforms:
  - name: centos
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: ubuntu
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
provisioner:
  name: ansible
verifier:
  name: ansible
```

описание информации:

| Секция       | Параметр                | Значение                                    |
|-------------------|-----------------------------|-------------------------------------------------|
| dependency     | name                        | galaxy                                          |
| driver         | name                        | podman                                         |
| platforms      | name (CentOS)              | centos                                         |
|                     | image (CentOS)             | docker.io/pycontribs/centos:8                  |
|                     | prebuildimage (CentOS)   | true                                           |
|                     | name (Ubuntu)              | ubuntu                                         |
|                     | image (Ubuntu)             | docker.io/pycontribs/ubuntu:latest             |
|                     | prebuildimage (Ubuntu)   | true                                           |
| provisioner    | name                        | ansible                                        |
| verifier       | name                        | ansible                                        |

результат ``` molecule init scenario --driver-name docker ```:

```
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector-role/molecule/default successfully.
alyona@alyona-FLAPTOP-r:~/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector-role$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/alyona/.cache/ansible-compat/f5bcd7/modules:/home/alyona/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/alyona/.cache/ansible-compat/f5bcd7/collections:/home/alyona/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/alyona/.cache/ansible-compat/f5bcd7/roles:/home/alyona/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
ERROR    Computed fully qualified role name of vector-role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.

Traceback (most recent call last):
  File "/home/alyona/.local/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/usr/lib/python3/dist-packages/click/core.py", line 1128, in __call__
    return self.main(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/click/core.py", line 1053, in main
    rv = self.invoke(ctx)
  File "/usr/lib/python3/dist-packages/click/core.py", line 1659, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/usr/lib/python3/dist-packages/click/core.py", line 1395, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/usr/lib/python3/dist-packages/click/core.py", line 754, in invoke
    return __callback(*args, **kwargs)
  File "/usr/lib/python3/dist-packages/click/decorators.py", line 26, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/home/alyona/.local/lib/python3.10/site-packages/molecule/command/test.py", line 176, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/home/alyona/.local/lib/python3.10/site-packages/molecule/command/base.py", line 112, in execute_cmdline_scenarios
    scenario.config.runtime.prepare_environment(
  File "/usr/local/lib/python3.10/dist-packages/ansible_compat/runtime.py", line 421, in prepare_environment
    self._install_galaxy_role(
  File "/usr/local/lib/python3.10/dist-packages/ansible_compat/runtime.py", line 581, in _install_galaxy_role
    raise InvalidPrerequisiteError(msg)
ansible_compat.errors.InvalidPrerequisiteError: Computed fully qualified role name of vector-role does not follow current galaxy requirements.
Please edit meta/main.yml and assure we can correctly determine full role name:

galaxy_info:
role_name: my_name  # if absent directory name hosting role is used instead
namespace: my_galaxy_namespace  # if absent, author is used instead

Namespace: https://galaxy.ansible.com/docs/contributing/namespaces.html#galaxy-namespace-limitations
Role: https://galaxy.ansible.com/docs/contributing/creating_role.html#role-names

As an alternative, you can add 'role-name' to either skip_list or warn_list.
```

Как можно заметить, имеется ошибка. Проблема заключается в том, что имя вашей роли vector-role не соответствует требованиям Ansible Galaxy, т.е. использование знаков "-". 

Решение: заменить знаки "-" на "_"

результат ```molecule test ```

```
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/alyona/.cache/ansible-compat/e3fa2b/modules:/home/alyona/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/alyona/.cache/ansible-compat/e3fa2b/collections:/home/alyona/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/alyona/.cache/ansible-compat/e3fa2b/roles:/home/alyona/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/alyona/.cache/ansible-compat/e3fa2b/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
...
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '708612613381.42290', 'results_file': '/home/alyona/.ansible_async/708612613381.42290', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
...
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '341440674071.42316', 'results_file': '/home/alyona/.ansible_async/341440674071.42316', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Download Vector] *******************************************
changed: [ubuntu]
changed: [centos8]

TASK [vector_role : Install Vector] ********************************************
fatal: [ubuntu]: FAILED! => {"ansible_facts": {"pkg_mgr": "apt"}, "changed": false, "msg": ["Could not detect which major revision of yum is in use, which is required to determine module backend.", "You should manually specify use_backend to tell the module whether to use the yum (yum3) or dnf (yum4) backend})"]}
fatal: [centos8]: FAILED! => {"changed": false, "msg": "Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist", "rc": 1, "results": []}

PLAY RECAP *********************************************************************
centos8                    : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

WARNING  Retrying execution failure 2 of: ansible-playbook --inventory /home/alyona/.cache/molecule/vector_role/default/inventory --skip-tags molecule-notest,notest /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml
CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/alyona/.cache/molecule/vector_role/default/inventory', '--skip-tags', 'molecule-notest,notest', '/home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

при установке vector произошли ошибки. после решения 

```
TASK [vector_role : Install Vector] ********************************************
fatal: [ubuntu]: FAILED! => {"ansible_facts": {"pkg_mgr": "apt"}, "changed": false, "msg": ["Could not detect which major revision of yum is in use, which is required to determine module backend.", "You should manually specify use_backend to tell the module whether to use the yum (yum3) or dnf (yum4) backend})"]}
fatal: [centos8]: FAILED! => {"changed": false, "msg": "Failed to download metadata for repo 'appstream': Cannot prepare internal mirrorlist: No URLs in mirrorlist", "rc": 1, "results": []}
```

итог ``` molecule test ````

```
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/alyona/.cache/ansible-compat/e3fa2b/modules:/home/alyona/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/alyona/.cache/ansible-compat/e3fa2b/collections:/home/alyona/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/alyona/.cache/ansible-compat/e3fa2b/roles:/home/alyona/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/alyona/.cache/ansible-compat/e3fa2b/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '779236596489.24942', 'results_file': '/home/alyona/.ansible_async/779236596489.24942', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '779101350467.24968', 'results_file': '/home/alyona/.ansible_async/779101350467.24968', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Prepare Centos] ********************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Prepare Centos] ********************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos8]
skipping: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos8]
skipping: [ubuntu]

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```


4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).

проверка на версию и на валидацию vector (смотреть vector_role/molecule/default/verify.yml)

```
---
# This is an example playbook to execute Ansible tests.
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
    - name: Include vars
      include_vars:
        file: ../../defaults/main.yml
        name: def_vars
    - name: Get Vector version
      shell: vector --version
      register: pkg_version
    - name: Test Vector version
      assert:
        that:
          - pkg_version: vector {{ def_vars.vector_version }}
    - name: Vector validate
      shell: vector validate
      register: vector_validate
    - name: Validate assert
      assert:
        that:
          - vector_validate.rc == 0
```

| Элемент                       | Описание                                                                                     |
|-----------------------------------|--------------------------------------------------------------------------------------------------|
| name: Verify                   | Название playbook, описывающее его цель — верификация.                                          |
| hosts: all                     | Указывает, что playbook будет выполняться на всех хостах, определенных в инвентаре.            |
| gather_facts: false            | Отключает сбор фактов о хостах перед выполнением задач.                                        |
| tasks:                         | Начало секции задач, которые будут выполнены на указанных хостах.                              |
| - name: Include vars           | Название задачи, которая включает переменные из указанного файла.                               |
| include_vars:                  | Модуль для включения переменных из файла.                                                      |
| file: ../../defaults/main.yml  | Путь к файлу, из которого будут загружены переменные.                                          |
| name: def_vars                 | Имя, под которым будут доступны загруженные переменные.                                         |
| - name: Get Vector version     | Название задачи, которая выполняет команду для получения версии Vector.                        |
| shell: vector --version        | Команда, которая будет выполнена на целевом хосте для получения версии Vector.                |
| register: pkg_version          | Сохраняет результат выполнения команды в переменной pkg_version.                              |
| - name: Test Vector version     | Название задачи, проверяющей корректность версии Vector.                                       |
| assert:                        | Модуль для выполнения проверки (assertion).                                                     |
| that:                          | Указывает условия, которые должны быть истинными для успешного выполнения задачи.              |
| - pkg_version: vector {{ def_vars.vector_version }} | Проверяет, что версия Vector соответствует ожидаемой версии из переменных.                    |
| - name: Vector validate        | Название задачи, которая выполняет команду для валидации конфигурации Vector.                  |
| shell: vector validate         | Команда для выполнения валидации конфигурации Vector на целевом хосте.                        |
| register: vector_validate      | Сохраняет результат выполнения команды в переменной vector_validate.                          |
| - name: Validate assert        | Название задачи, проверяющей результат выполнения валидации.                                   |
| assert:                        | Модуль для выполнения проверки (assertion).                                                     |
| that:                          | Указывает условия для проверки результата выполнения команды валидации.                        |
| - vector_validate.rc == 0     | Проверяет, что код возврата команды валидации равен 0 (успешное выполнение).                   |


5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

```
molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/home/alyona/.cache/ansible-compat/e3fa2b/modules:/home/alyona/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/alyona/.cache/ansible-compat/e3fa2b/collections:/home/alyona/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/alyona/.cache/ansible-compat/e3fa2b/roles:/home/alyona/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/alyona/.cache/ansible-compat/e3fa2b/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=Centos)
ok: [localhost] => (item=Ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '617322976601.28032', 'results_file': '/home/alyona/.ansible_async/617322976601.28032', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '248338109766.28058', 'results_file': '/home/alyona/.ansible_async/248338109766.28058', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'Ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Centos]
ok: [Ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
fatal: [Centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001739", "end": "2023-03-21 20:09:38.024975", "msg": "non-zero return code", "rc": 2, "start": "2023-03-21 20:09:38.023236", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
skipping: [Ubuntu]
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [Centos]
changed: [Ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [Centos]
changed: [Ubuntu]

PLAY RECAP *********************************************************************
Centos                     : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1
Ubuntu                     : ok=3    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Centos]
ok: [Ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
fatal: [Centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001824", "end": "2023-03-21 20:10:26.013544", "msg": "non-zero return code", "rc": 2, "start": "2023-03-21 20:10:26.011720", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
skipping: [Ubuntu]
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [Ubuntu]
changed: [Centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [Ubuntu]
ok: [Centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [Ubuntu]
ok: [Centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [Centos]
ok: [Ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [Centos]
changed: [Ubuntu]

PLAY RECAP *********************************************************************
Centos                     : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1
Ubuntu                     : ok=3    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

CRITICAL Idempotence test failed because of the following tasks:
* [Centos] => vector_role : Prepare Centos
* [Ubuntu] => vector_role : Install Vector Ubuntu
WARNING  An error occurred during the test sequence action: 'idempotence'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=Centos)
changed: [localhost] => (item=Ubuntu)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
```

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

https://github.com/Kulikova-A18/vector-role/releases/tag/v0.0.1-alpha


### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).

Cмотреть tox.ini по пути: vector-role/tox.ini

```
[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s default --destroy always}
```

Cмотреть tox-requirements.txt по пути: vector-role/tox-requirements.txt

```
selinux
ansible-lint==5.1.3
yamllint==1.26.3
lxml
molecule==3.4.0
molecule_podman
jmespath
```

2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.

```
docker run --privileged=True -v ~/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
```

3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

> возникли трудности при выполнении задания как в локальной среде, так и посредством предложенного командой Docker-образа. Несмотря на усилия, проблема осталась нерешенной. видимо и в задании нет требований по устранению данной неисправности

```
tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.1.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='3762053039'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.1.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='3762053039'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.3,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='3762053039'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==3.0.1,ansible-core==2.14.3,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.2.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.17.3,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,pyrsistent==0.19.3,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,resolvelib==0.8.1,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='3762053039'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
____________________________________________________________________________________ summary ____________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```

4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

если запустить полный сценарий, то отображается только в конце

```
python3 -m tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.1.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='3489487170'
py37-ansible210 run-test: commands[0] | molecule test -s default --destroy always
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/alyona/Documents/DevOpsTask as project root directory
INFO     Using /home/alyona/.cache/ansible-lint/cf8d39/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/alyona/.cache/ansible-lint/cf8d39/roles
INFO     Running default > dependency
INFO     Running ansible-galaxy collection install --force -v containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install --force -v ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '524462627738.20466', 'results_file': '/home/alyona/.ansible_async/524462627738.20466', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '91258935304.20494', 'results_file': '/home/alyona/.ansible_async/91258935304.20494', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos registry username: None specified") 
skipping: [localhost] => (item="ubuntu registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8") 
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/ubuntu:latest") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos)
ok: [localhost] => (item=ubuntu)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=docker.io/pycontribs/ubuntu:latest) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos command: None specified")
ok: [localhost] => (item="ubuntu command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos: None specified) 
skipping: [localhost] => (item=ubuntu: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (292 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (291 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (290 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (289 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (288 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (287 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (286 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (285 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (284 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (283 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (282 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (281 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (280 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (279 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (278 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (277 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (276 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (275 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (274 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (273 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (272 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (271 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (270 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (269 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (268 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (267 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (266 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (265 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (264 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (263 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (262 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (261 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (260 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (259 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (258 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (257 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (256 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (255 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (254 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (253 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (252 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (251 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (250 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (249 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (248 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (247 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (246 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (245 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (244 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (243 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (242 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (241 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (240 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (239 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (238 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (237 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (236 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (235 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (234 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (233 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (232 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (231 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (230 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (229 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (228 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (227 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (226 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (225 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (224 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (223 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (222 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (221 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (220 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (219 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (218 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (217 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (216 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (215 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (214 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (213 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (212 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (211 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (210 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (209 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (208 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (207 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (206 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (205 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (204 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (203 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (202 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (201 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (200 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (199 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (198 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (197 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (196 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (195 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (194 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (193 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (192 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (191 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (190 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (189 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (188 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (187 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (186 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (185 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (184 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (183 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (182 retries left).
changed: [localhost] => (item=centos)
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
changed: [localhost] => (item=ubuntu)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos]
ok: [ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
skipping: [ubuntu]
fatal: [centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001660", "end": "2023-03-22 20:59:40.212492", "msg": "non-zero return code", "rc": 2, "start": "2023-03-22 20:59:40.210832", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos]
changed: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos]
changed: [ubuntu]

PLAY RECAP *********************************************************************
centos                     : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1   
ubuntu                     : ok=3    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos]
ok: [ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
skipping: [ubuntu]
fatal: [centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001590", "end": "2023-03-22 21:00:40.904237", "msg": "non-zero return code", "rc": 2, "start": "2023-03-22 21:00:40.902647", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [ubuntu]
ok: [centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [ubuntu]
ok: [centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos]
ok: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos]
changed: [ubuntu]

PLAY RECAP *********************************************************************
centos                     : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1   
ubuntu                     : ok=3    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

CRITICAL Idempotence test failed because of the following tasks:
*  => vector_role : Prepare Centos
*  => vector_role : Install Vector Ubuntu
WARNING  An error occurred during the test sequence action: 'idempotence'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '742338640298.36432', 'results_file': '/home/alyona/.ansible_async/742338640298.36432', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '125979933025.36460', 'results_file': '/home/alyona/.ansible_async/125979933025.36460', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/.tox/py37-ansible210/bin/molecule test -s default --destroy always (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.12.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.1.0,click==8.1.3,click-help-colors==0.9.1,cookiecutter==2.1.1,cryptography==39.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.1.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.2,markdown-it-py==2.2.0,MarkupSafe==2.1.2,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.0,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.14.0,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.28.2,rich==13.3.2,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.5.0,urllib3==1.26.15,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='3489487170'
py37-ansible30 run-test: commands[0] | molecule test -s default --destroy always
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Guessed /home/alyona/Documents/DevOpsTask as project root directory
INFO     Using /home/alyona/.cache/ansible-lint/cf8d39/roles/my_galaxy_namespace.vector_role symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/home/alyona/.cache/ansible-lint/cf8d39/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '114165305187.36949', 'results_file': '/home/alyona/.ansible_async/114165305187.36949', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '883906787888.36977', 'results_file': '/home/alyona/.ansible_async/883906787888.36977', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos registry username: None specified") 
skipping: [localhost] => (item="ubuntu registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:8") 
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/ubuntu:latest") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos)
ok: [localhost] => (item=ubuntu)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=docker.io/pycontribs/ubuntu:latest) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos command: None specified")
ok: [localhost] => (item="ubuntu command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos: None specified) 
skipping: [localhost] => (item=ubuntu: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos)
changed: [localhost] => (item=ubuntu)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos]
ok: [ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
skipping: [ubuntu]
fatal: [centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001606", "end": "2023-03-22 21:01:18.304115", "msg": "non-zero return code", "rc": 2, "start": "2023-03-22 21:01:18.302509", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos]
changed: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos]
changed: [ubuntu]

PLAY RECAP *********************************************************************
centos                     : ok=5    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1   
ubuntu                     : ok=3    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos]
ok: [ubuntu]

TASK [Include vector_role] *****************************************************

TASK [vector_role : Check need prepare Centos] *********************************
skipping: [ubuntu]
fatal: [centos]: FAILED! => {"changed": true, "cmd": ["grep", "http://vault.centos.org/$contentdir/$releasever/PowerTools/$basearch/os/", "/etc/yum.repos.d/CentOS-*"], "delta": "0:00:00.001574", "end": "2023-03-22 21:02:13.902665", "msg": "non-zero return code", "rc": 2, "start": "2023-03-22 21:02:13.901091", "stderr": "grep: /etc/yum.repos.d/CentOS-*: No such file or directory", "stderr_lines": ["grep: /etc/yum.repos.d/CentOS-*: No such file or directory"], "stdout": "", "stdout_lines": []}
...ignoring

TASK [vector_role : Prepare Centos] ********************************************
skipping: [ubuntu]
changed: [centos]

TASK [vector_role : Download Vector for Centos] ********************************
skipping: [ubuntu]
ok: [centos]

TASK [vector_role : Install Vector Centos] *************************************
skipping: [ubuntu]
ok: [centos]

TASK [vector_role : Download Vector Ubuntu] ************************************
skipping: [centos]
ok: [ubuntu]

TASK [vector_role : Install Vector Ubuntu] *************************************
skipping: [centos]
changed: [ubuntu]

PLAY RECAP *********************************************************************
centos                     : ok=5    changed=2    unreachable=0    failed=0    skipped=2    rescued=0    ignored=1   
ubuntu                     : ok=3    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

CRITICAL Idempotence test failed because of the following tasks:
*  => vector_role : Prepare Centos
*  => vector_role : Install Vector Ubuntu
WARNING  An error occurred during the test sequence action: 'idempotence'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True})
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '6680371794.49161', 'results_file': '/home/alyona/.ansible_async/6680371794.49161', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'centos', 'pre_build_image': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '939783091107.49189', 'results_file': '/home/alyona/.ansible_async/939783091107.49189', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /home/alyona/Documents/Kulikova-A18/NETOLOGY-SHVIRTD-17/08-ansible-05-testing/vector_role/.tox/py37-ansible30/bin/molecule test -s default --destroy always (exited with code 1)
____________________________________________________________________________________ summary ____________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
```

5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

> решено в пункте 4

6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

> решено в пункте 4

7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

https://github.com/Kulikova-A18/vector-role/releases/tag/v0.0.1-alpha
