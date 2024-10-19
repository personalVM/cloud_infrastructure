
# data "google_secret_manager_secret_version" "tf_secretrpw" {
#   secret = "rstudio-passwd"
#   version = "latest"
# }

# data "google_secret_manager_secret_version" "tf_secretgitprivsshk" {
#   secret = "github-private-ssh-key"
#   version = "latest"
# }

resource "google_compute_address" "tf_static_ip" {
  name         = "${var.svc_name}-static-ip"
  region       = var.location
}

resource "google_compute_instance" "tf_vm" {
  name         = "computeinstance-${var.svc_name}"
  machine_type = var.machine_type
  zone         = var.zone
  allow_stopping_for_update = true
  boot_disk {
    initialize_params {
      #   image = "projects/YOUR_PROJECT_ID/global/images/YOUR_IMAGE_NAME"
      image = "ubuntu-2204-jammy-v20240927"
      size  = 200
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
      nat_ip = google_compute_address.tf_static_ip.address
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
  # metadata = {
  #   "install-nvidia-driver" = var.gpu_enabled ? "true" : "false"
  #   "user-data"             = <<-EOF
  #     #!/bin/bash

  #     sudo apt update -y
      
  #     sudo apt install tree -y
      
  #     sudo apt install -y docker.io
  #     sudo systemctl start docker
  #     sudo systemctl enable docker
      
  #     sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  #     sudo chmod +x /usr/local/bin/docker-compose
      
  #     sudo apt-get install nginx
  #     sudo systemctl enable nginx
  #     sudo systemctl start nginx

  #     sudo docker pull rocker/geospatial
  #     sudo docker run -d \
  #       -p 8787:8787 \
  #       --name rstudio \
  #       -e ROOT=true \
  #       -e USER=rstudio \
  #       -e PASSWORD=${data.google_secret_manager_secret_version.tf_secretrpw.secret_data} \
  #       --user root \
  #       rocker/geospatial

  #     sleep 2

  #     sudo docker exec -t rstudio bash -c '

  #       sudo apt update -y
  #       sudo apt install tree -y

  #       mkdir -p ~/.ssh
  #       echo -e "${data.google_secret_manager_secret_version.tf_secretgitprivsshk.secret_data}" > ~/.ssh/id_rsa
  #       chmod 600 ~/.ssh/id_rsa

  #       touch ~/.ssh/known_hosts
  #       ssh-keyscan -H github.com > ~/.ssh/known_hosts
  #       chmod 600 ~/.ssh/known_hosts

  #       eval "$(ssh-agent -s)"
  #       ssh-add ~/.ssh/id_rsa
  #       git config --global user.email "guilhermeviegas1993@gmail.com"
  #       git config --global user.name "Gui-go"

  #       git clone git@github.com:Gui-go/BRdb.git /home/rstudio/BRdb/
  #       git config --global --add safe.directory /home/rstudio/BRdb/

  #       chown -R rstudio:rstudio /home/rstudio/

  #     '

  #     mkdir -p /home/guilhermeviegas1993/data/clean_data/{munic,micro,meso,rgint,rgime,uf}
  #     mkdir -p /home/guilhermeviegas1993/data/curated_data/{munic,micro,meso,rgint,rgime,uf}
  #     sudo chmod -R 777 /home/guilhermeviegas1993/data/
  #     sudo gsutil -m cp -r gs://${var.cleanbucket_name}/* /home/guilhermeviegas1993/data/clean_data      
  #     sudo docker cp /home/guilhermeviegas1993/data/. rstudio:/home/rstudio/data/

  #     # sudo gsutil -m cp -r /home/guilhermeviegas1993/data/curated_data gs://brcompute-curatedbucket/*

  #     echo "VM init finished!"

  #   EOF    
  # }
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

resource "google_dns_managed_zone" "tf_dns_zone" {
  name        = "${var.svc_name}-dns-zone"
  dns_name    = "guigo.dev.br."
  description = "My DNS zone"
}

resource "google_dns_record_set" "tf_a_record" {
  name         = "guigo.dev.br."
  managed_zone = google_dns_managed_zone.tf_dns_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.tf_static_ip.address]
}

resource "google_dns_record_set" "tf_www_a_record" {
  name         = "www.guigo.dev.br."
  managed_zone = google_dns_managed_zone.tf_dns_zone.name
  type         = "A"
  ttl          = 300
  rrdatas      = [google_compute_address.tf_static_ip.address]
}

resource "google_service_account" "tf_vm_service_account" {
  account_id   = "${var.svc_name}-serviceaccount"
  display_name = "Service account for VM to access GCS"
}

resource "google_project_iam_member" "tf_vm_storage_access" {
  project = var.proj_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.tf_vm_service_account.email}"
}

