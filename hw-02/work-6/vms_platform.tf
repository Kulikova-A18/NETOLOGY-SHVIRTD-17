variable "vm_db_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "yandex compute instance zone"
}
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "yandex compute instance platform id"
}
variable "vm_db_preemptible" {
  type        = bool
  default     = true
  description = "yandex compute instance scheduling policy preemptible"
}
variable "vm_db_nat" {
  type        = bool
  default     = true
  description = "yandex compute instance network interface nat"
}
variable "vm_db_env" {
  type        = string
  default     = "develop"
  description = "yandex compute instance name env"
}
variable "vm_db_project" {
  type        = string
  default     = "platform"
  description = "yandex compute instance name project"
}
variable "vm_db_role" {
  type        = string
  default     = "db"
  description = "yandex compute instance name role"
}
