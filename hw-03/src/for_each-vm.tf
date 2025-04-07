variable "os_image" {
  type    = string
  default = "ubuntu-2004-lts"
}

data "yandex_compute_image" "ubuntu" {
  family = var.os_image
}

# Переменная для настройки ресурсов виртуальных машин
variable "vm_resources" {
  type = list(object({
    vm_name     = string          # Имя ВМ
    cpu         = number          # Количество ядер
    ram         = number          # Объем памяти
    disk        = number          # Размер диска
    platform_id = string          # Идентификатор платформы
  }))

  default = [
    {
      vm_name     = "main"         # Имя ВМ
      cpu         = 2              # Количество ядер
      ram         = 2              # Объем памяти
      disk        = 5              # Размер диска
      platform_id = "standard-v1"  # Идентификатор платформы
    },
    {
      vm_name     = "replica"      # Имя реплики ВМ
      cpu         = 2              # Количество ядер
      ram         = 2              # Объем памяти
      disk        = 10             # Размер диска
      platform_id = "standard-v1"  # Идентификатор платформы
    },
  ]
}

locals {
  ssh_keys = file("~/.ssh/id_ed25519.pub")
}

resource "yandex_compute_instance" "instances" {
  depends_on = [yandex_compute_instance.web]

  for_each = { for vm in var.vm_resources : vm.vm_name => vm }
  
  name        = each.value.vm_name                   # Имя ВМ
  platform_id = each.value.platform_id               # Идентификатор платформы

  resources {
    cores  = each.value.cpu                           # Количество ядер
    memory = each.value.ram                           # Объем памяти
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id  # ID образа для загрузочного диска
      size     = each.value.disk                            # Размер диска
    }
  }

  metadata = {
    ssh-keys           = local.ssh_keys
    serial-port-enable = "1"
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  scheduling_policy {
    preemptible = true
  }
}
