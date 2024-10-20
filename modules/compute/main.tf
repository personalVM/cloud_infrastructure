
data "google_secret_manager_secret_version" "tf_secretrpw" {
  secret = "rstudio-passwd"
  version = "latest"
}

data "google_secret_manager_secret_version" "tf_secretgitprivsshk" {
  secret = "github-private-ssh-key"
  version = "latest"
}

resource "google_compute_instance" "tf_vm" {
  name         = "${var.proj_name}-${var.svc_name}"
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      #   image = "projects/YOUR_PROJECT_ID/global/images/YOUR_IMAGE_NAME"
      image = "ubuntu-2204-jammy-v20240927"
      size  = 100
      type  = "pd-ssd"
    }
  }
  # attached_disk {
  #   source      = google_compute_disk.tf_disk.id
  #   device_name = "additional-disk-${var.svc_name}"
  # }
  network_interface {
    network = var.network_name
    access_config {
      nat_ip = var.static_ip_address
    }
  }
  dynamic "guest_accelerator" {
    for_each = var.gpu_enabled ? [1] : []
    content {
      type  = var.gpu_type
      count = 1
    }
  }
  scheduling {
    preemptible       = false
    automatic_restart = true
    on_host_maintenance = "TERMINATE"
  }
  metadata = {
    "install-nvidia-driver" = var.gpu_enabled ? "true" : "false"
    "user-data"             = <<-EOF
      #!/bin/bash

      echo "export cleanbucket_name=${var.cleanbucket_name}" >> /home/guilhermeviegas1993/.bashrc
      echo "export rstudio_secret=${data.google_secret_manager_secret_version.tf_secretrpw.secret_data}" >> /home/guilhermeviegas1993/.bashrc 
      echo "${data.google_secret_manager_secret_version.tf_secretgitprivsshk.secret_data}" > /home/guilhermeviegas1993/.github-private-ssh-key
      chmod 600 /home/guilhermeviegas1993/.github-private-ssh-key

      sudo apt update -y
      
      sudo apt install tree -y
      
      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo systemctl enable docker
      
      sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
      
      sudo apt-get install nginx
      sudo systemctl enable nginx
      sudo systemctl start nginx

      sudo docker pull rocker/geospatial

      mkdir -p /home/guilhermeviegas1993/data/clean_data/{munic,micro,meso,rgint,rgime,uf}
      mkdir -p /home/guilhermeviegas1993/data/curated_data/{munic,micro,meso,rgint,rgime,uf}
      sudo chmod -R 777 /home/guilhermeviegas1993/data/
      sudo gsutil -m cp -r gs://$cleanbucket_name/* /home/guilhermeviegas1993/data/clean_data      

      echo "VM init finished!"

    EOF    
  }
  service_account {
    email  = google_service_account.tf_vm_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# resource "google_compute_disk" "tf_disk" {
#   name  = "additional-disk"
#   type  = "pd-ssd"
#   size  = 200
#   zone  = var.zone
# }

resource "google_service_account" "tf_vm_service_account" {
  account_id   = "${var.svc_name}-serviceaccount"
  display_name = "Service account for VM to access GCS"
}

resource "google_project_iam_member" "tf_vm_storage_access" {
  project = var.proj_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.tf_vm_service_account.email}"
}

