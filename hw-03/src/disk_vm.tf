
variable "storage_secondary_disk" {
  type = list(object({
    for_storage = object({
      type       = string   # Тип диска
      size       = number   # Размер диска
      count      = number   # Количество дисков
      block_size = number   # Размер блока диска
      name       = string   # Имя диска
    })
  }))

  default = [
    {
      for_storage = {
        type       = "network-hdd"    # тип диска
        size       = 1                # размер диска
        count      = 3                # 3 диска
        block_size = 4096             # размер блока на 4096 байт
        name       = "disk"           # Имя диска
      }
    }
  ]
}

resource "yandex_compute_disk" "disks" {
  count       = var.storage_secondary_disk[0].for_storage.count                         # Количество дисков
  name        = "${var.storage_secondary_disk[0].for_storage.name}-${count.index + 1}"  # Имя диска с индексом
  type        = var.storage_secondary_disk[0].for_storage.type                          # Тип диска
  size        = var.storage_secondary_disk[0].for_storage.size                          # Размер диска
  block_size  = var.storage_secondary_disk[0].for_storage.block_size                    # Размер блока диска
}

variable "yandex_compute_instance_storage" {
  type = object({
    storage_resources = object({
      cores         = number    # Количество ядер
      memory        = number    # Объем памяти
      core_fraction  = number   # Доля ядра
      name          = string    # Имя ВМ
      zone          = string    # Зона ВМ
    })
  })

  default = {
    storage_resources = {
      cores         = 2                # количество ядер
      memory        = 2                # объем памяти
      core_fraction  = 5               # доля ядра
      name          = "storage"        # Имя ВМ
      zone          = "ru-central1-a"  # Зона размещения
    }
  }
}

variable "boot_disk_storage" {
  type = object({
    size = number   # Размер диска
    type = string   # Тип диска
  })
  
  default = {
    size = 5                  # размер диска
    type = "network-hdd"      # тип диска
  }
}

resource "yandex_compute_instance" "storage" {
  name = var.yandex_compute_instance_storage.storage_resources.name # Имя ВМ
  zone = var.yandex_compute_instance_storage.storage_resources.zone # Зона размещения ВМ

  resources {
    cores         = var.yandex_compute_instance_storage.storage_resources.cores          # Количество ядер
    memory        = var.yandex_compute_instance_storage.storage_resources.memory         # Объем памяти
    core_fraction  = var.yandex_compute_instance_storage.storage_resources.core_fraction # Доля ядра
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id   # ID образа диска
      type     = var.boot_disk_storage.type                           # Тип диска
      size     = var.boot_disk_storage.size                           # Размер диска
    }
  }

  metadata = {
    ssh-keys           = file("~/.ssh/id_ed25519.pub")               
    serial-port-enable = "1"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id               # ID подсети ВМ
    nat                = true                                       # NAT
    security_group_ids = [yandex_vpc_security_group.example.id]     # группа безопасности ВМ
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks.*.id                       # все вторичные диски, созданные ранее
    content {
      disk_id = secondary_disk.value                                # Привязываем каждый вторичный диск к ВМ
    }
  }
}
