output "external_load_balancer_ip" {
  value = yandex_lb_network_load_balancer.load-balancer-1.listener.*.external_address_spec[0].*.address[0]
}

output "bucket_domain_name" {
  value = "http://${yandex_storage_bucket.netology-bucket.bucket_domain_name}/458abb04cf5593a4e7dda9819bcc219e.jpg"
}
