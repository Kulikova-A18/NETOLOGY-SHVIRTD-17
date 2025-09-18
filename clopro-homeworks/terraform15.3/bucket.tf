resource "yandex_iam_service_account" "bucket-sa-a" {
  name      = "bucket-sa-a"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yandex_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa-a.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-sa-a.id
  description        = "static access key for bucket-sa object storage"
}

  resource "yandex_kms_symmetric_key" "key-a" {
  name              = "netology-key"
  description       = "description yandex_kms_symmetric_key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}

resource "yandex_storage_bucket" "bucket-for-web-1" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "awertoss-netology-bucket"
  acl    = "public-read"


  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  anonymous_access_flags {
    read = true
    list = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
  }
  }


}

resource "yandex_storage_object" "index" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.bucket-for-web-1.id
  key        = "index.html"
  source     = "${path.module}/site/index.html"
}

resource "yandex_storage_object" "error" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.bucket-for-web-1.id
  key        = "error.html"
  source     = "${path.module}/site/error.html"
}

