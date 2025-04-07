variable "os_image_web" {
  type    = string
  default = "ubuntu-2004-lts"
}

data "yandex_compute_image" "ubuntu_2004_lts" {
  family = var.os_image_web
}

variable "yandex_compute_instance_web" {
  type = list(object({
    vm_name       = string   # Имя ВМ
    cores         = number   # Количество ядер
    memory        = number   # Объем памяти
    core_fraction = number   # Доля ядра
    count_vms     = number   # Количество ВМ
    platform_id   = string   # Идентификатор платформы ВМ
  }))

  default = [{
    vm_name       = "web"           # Имя ВМ
    cores         = 2               # Количество ядер
    memory        = 1               # Объем памяти
    core_fraction = 5               # Доля ядра
    count_vms     = 2               # 2 ВМ
    platform_id   = "standard-v1"   # Платформа стандартного типа
  }]
}

variable "boot_disk_web" {
  type = list(object({
    size = number  # Размер диска
    type = string  # Тип диска
  }))

  default = [{
    size = 5                  # Размер диска
    type = "network-hdd"      # Тип диска
  }]
}

resource "yandex_compute_instance" "web" {
  count       = var.yandex_compute_instance_web[0].count_vms                        # количество создаваемых ВМ
  name        = "${var.yandex_compute_instance_web[0].vm_name}-${count.index + 1}"  # имя ВМ
  platform_id = var.yandex_compute_instance_web[0].platform_id                      # идентификатор платформы

  resources {
    cores         = var.yandex_compute_instance_web[0].cores         # количество ядер
    memory        = var.yandex_compute_instance_web[0].memory        # объем памяти
    core_fraction = var.yandex_compute_instance_web[0].core_fraction # доля ядра
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2004_lts.image_id  # ID образа для загрузочного диска
      type     = var.boot_disk_web[0].type                           # тип диска
      size     = var.boot_disk_web[0].size                           # размер диска
    }
  }

  metadata = {
    ssh-keys             = file("~/.ssh/id_ed25519.pub")
    serial-port-enable   = "1" # последовательный порт для отладки
  }

  network_interface {
    subnet_id            = yandex_vpc_subnet.develop.id           # ID подсети, в которой будет находиться ВМ
    nat                  = true                                   # NAT для доступа к интернету
    security_group_ids   = [yandex_vpc_security_group.example.id] # группа безопасности к ВМ
  }

  scheduling_policy {
    preemptible          = true # ВМ может быть прерываемой
  }
}
