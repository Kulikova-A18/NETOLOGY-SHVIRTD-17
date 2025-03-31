output "instances_info" {
  description = "instances info"
  value       = [
    {
      instance_name = yandex_compute_instance.platform.name
      external_ip = var.vm_external_ips[0]
      fqdn = var.vm_fqdns[0]
    },
    {
      instance_name = yandex_compute_instance.platform_db.name
      external_ip = var.vm_external_ips[1]
      fqdn = var.vm_fqdns[1]
    }
  ]
}
