resource "yandex_vpc_network" "network-1" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet-public" {
  name           = "public"
  zone           = var.b-zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.200.0/24"]
}
