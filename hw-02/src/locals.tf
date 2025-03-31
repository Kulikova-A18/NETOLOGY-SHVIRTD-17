locals {
  name_web = "netology-${var.vpc_name}-${var.default_zone}-web"
  name_db  = "netology-${var.vm_db_vpc_name}-${var.vm_db_default_zone}-db"
}
