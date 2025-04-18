###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "yandex compute image family"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "yandex compute instance platform id"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "yandex compute instance scheduling policy preemptible"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "yandex compute instance network interface nat"
}

variable "vm_external_ips" {
  type        = list(string)
  default     = ["158.160.83.76", "158.160.83.77"]
  description = "yandex compute instance vm ip-addresses"
}

variable "vm_fqdns" {
  type        = list(string)
  default     = ["netology.develop.platform.web", "netology.develop.platform.db"]
  description = "yandex compute instance vm fully qualified domain names"
}

variable "vm_web_env" {
  type        = string
  default     = "develop"
  description = "yandex compute instance name env"
}
variable "vm_web_project" {
  type        = string
  default     = "platform"
  description = "yandex compute instance name project"
}
variable "vm_web_role" {
  type        = string
  default     = "web"
  description = "yandex compute instance name role"
}

variable "vms_resources" {
  description = "единая map-переменная"
  type = map(object({
      cores         = number
      memory        = number
      core_fraction = number
  }))

  default = {
    web = {
        cores        = 2
        memory       = 1
        core_fraction = 20
    },
    db = {
        cores        = 2
        memory       = 2
        core_fraction = 20
    }
  }
}

variable "metadata" {
  description = "общая для всех ВМ"
  type = map(object({
      serial-port-enable = number
      ssh-keys           = string
  }))

  default = {
    web = {
        serial-port-enable = 1
        ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdzhSSCkC4KHgc50fUzvWrFGRhHPC+VPAmo3BAZlbWfkNt731m1SFa59slFV8cpxSF5H3c4zBXGoYw5ksfLnZYr/sZ6j7kL7QXSGpbIHEbUOQHP5CMWf/aCXUmF0PTFZIQjvY9ULOXgH+nyylc0uyf/86iubLxT458wmzojDTrGJh20ybllV7zazV5YUCjcsBqSB21dTCLRlCVpnjVNbA6aGCPF47o9ZLcTLPGx4OH+fX4kS/I3LwHV2L1HAtzKpGoN5gfLdkrG8ZjTzvdQaxIvVU4Tg8nn9MPBKe7qgF8IU4wuBUregTp9O49FQABvyX1Oac12iNsdaRAZDt6E7sxzTJDBFuxiODhfzFXPk/Ey9kyTDMlp5fHA3pDU4uE9B9XRotw/Neuj33RDIrsUj+YU3Ic7DYgF5ul8XTpB5x2dHJKGo8tBncxn2610eUGJsv+Q5mMf6SkNyNSmSZaVV1QtM7UpiFDISxsXfrE1only/N/TSpJRm8PrP9lQKUCh+U= user@DESKTOP-INFFBBO"
    },
    db = {
        serial-port-enable = 1
        ssh-keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCdzhSSCkC4KHgc50fUzvWrFGRhHPC+VPAmo3BAZlbWfkNt731m1SFa59slFV8cpxSF5H3c4zBXGoYw5ksfLnZYr/sZ6j7kL7QXSGpbIHEbUOQHP5CMWf/aCXUmF0PTFZIQjvY9ULOXgH+nyylc0uyf/86iubLxT458wmzojDTrGJh20ybllV7zazV5YUCjcsBqSB21dTCLRlCVpnjVNbA6aGCPF47o9ZLcTLPGx4OH+fX4kS/I3LwHV2L1HAtzKpGoN5gfLdkrG8ZjTzvdQaxIvVU4Tg8nn9MPBKe7qgF8IU4wuBUregTp9O49FQABvyX1Oac12iNsdaRAZDt6E7sxzTJDBFuxiODhfzFXPk/Ey9kyTDMlp5fHA3pDU4uE9B9XRotw/Neuj33RDIrsUj+YU3Ic7DYgF5ul8XTpB5x2dHJKGo8tBncxn2610eUGJsv+Q5mMf6SkNyNSmSZaVV1QtM7UpiFDISxsXfrE1only/N/TSpJRm8PrP9lQKUCh+U= user@DESKTOP-INFFBBO"
    }
  }
}
