
resource "google_storage_bucket" "tf_rawbucket" {
  name          = "${var.proj_name}-rawbucket"
  project       = var.proj_id
  location      = var.location
  storage_class = "COLDLINE" # NEARLINE COLDLINE ARCHIVE
  lifecycle_rule {
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
    condition {
      age = 180 # Move to ARCHIVE after 180 days
    }
  }
  labels = {
    environment = "varproj_name"
    project     = var.proj_id
    owner       = var.tag_owner
  }
}

resource "google_storage_bucket" "tf_cleanbucket" {
  name          = "${var.proj_name}-cleanbucket"
  project       = var.proj_id
  location      = var.location
  storage_class = "STANDARD"
  # logging {
  #   log_bucket        = google_storage_bucket.tfgcplogbucket.name
  #   log_object_prefix = "logs/"
  # }
  labels = {
    environment = var.proj_name
    project     = var.proj_id
    owner       = var.tag_owner
  }
}

resource "google_storage_bucket" "tf_curatedbucket" {
  name          = "${var.proj_name}-curatedbucket"
  project       = var.proj_id
  location      = var.location
  storage_class = "STANDARD"
  labels = {
    environment = var.proj_name
    project     = var.proj_id
    owner       = var.tag_owner
  }
}


# resource "google_storage_bucket" "tfgcplogbucket" {
#   name          = "${var.proj_name}-logbucket"
#   project       = var.proj_id
#   location      = var.location
#   storage_class = "STANDARD"
#   labels = {
#     environment = var.proj_name
#     project     = var.proj_id
#     owner       = var.tag_owner
#   }
# }