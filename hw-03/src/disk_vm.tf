variable "default_zone" {
  description = "Default availability zone"
  type        = string
}

variable "disk_size" {
  description = "Size of the secondary disks in GB"
  type        = number
  default     = 1
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 20
}

variable "instance_memory" {
  description = "Memory for the instance in GB"
  type        = number
  default     = 2
}

variable "instance_cores" {
  description = "Number of cores for the instance"
  type        = number
  default     = 2
}

resource "yandex_compute_disk" "storage_disk" {
  for_each = toset(["disk1", "disk2", "disk3"])

  name = "storage-disk-${each.key}"
  size = var.disk_size
  type = "network-hdd"
  zone = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone

  boot_disk {
    initialize_params {
      image_id = "fd8chrq89mmk8tqm85r8"
      size     = var.boot_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id           = yandex_vpc_subnet.develop.id
    nat                 = true
    security_group_ids  = ["enpce7huph0t1kvtivnk"]
  }

  resources {
    memory = var.instance_memory
    cores  = var.instance_cores
  }

  metadata = {
    ssh-keys = file("~/.ssh/id_ed25519.pub")
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disk
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
