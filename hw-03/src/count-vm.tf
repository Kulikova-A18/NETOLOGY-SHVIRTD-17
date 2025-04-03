resource "yandex_compute_instance" "web" {
  count = 2  # 2 экземпляра ВМ

  name        = "web-${count.index + 1}"   # "web-1" и "web-2"
  platform_id = "standard-v1"              # тип виртуальной машины
  zone        = var.default_zone           # размещен экземпляр, задается из переменной

  boot_disk {
    initialize_params {
      image_id = "fd8chrq89mmk8tqm85r8"
      size     = 30                 # размер диска
      type     = "network-hdd"      # тип диска
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = ["enppnvqd1388ibcdil9p"]
  }

  resources {
    memory = 2    # объем оперативной памяти в ГБ
    cores  = 2    # кол-во виртуальных процессоров
  }

  metadata = {
    ssh-keys = file("~/yan.pub")
  }
}
