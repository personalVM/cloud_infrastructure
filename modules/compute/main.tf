
data "google_secret_manager_secret_version" "tf_mainuser" {
  secret = "main-user"
  version = "latest"
}

data "google_secret_manager_secret_version" "tf_mainsecret" {
  secret = "main-passwd"
  version = "latest"
}

data "google_secret_manager_secret_version" "tf_secretgitprivsshk" {
  secret = "secret-gcp-ssh-key"
  version = "latest"
}

resource "google_compute_instance" "tf_computeinstance" {
  name         = "${var.proj_name}-computeinstance"
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

      sudo usermod -aG sudo guilhermeviegas1993

      echo "Setting parameters ------------------------------------------"
      export HOME=/home/guilhermeviegas1993
      echo "export cleanbucket_name=${var.cleanbucket_name}" >> /home/guilhermeviegas1993/.bashrc
      echo "export rstudio_secret=${data.google_secret_manager_secret_version.tf_mainsecret.secret_data}" >> /home/guilhermeviegas1993/.bashrc 
      mkdir -p ~/.ssh
      echo "${data.google_secret_manager_secret_version.tf_secretgitprivsshk.secret_data}" > /home/guilhermeviegas1993/.ssh/id_rsa
      chown guilhermeviegas1993:guilhermeviegas1993 /home/guilhermeviegas1993/.ssh/id_rsa
      chmod 700 /home/guilhermeviegas1993/.ssh/id_rsa
      sudo chown -R guilhermeviegas1993:guilhermeviegas1993 /home/guilhermeviegas1993/

      echo "Update ------------------------------------------------------"
      sudo apt update -y
      sudo apt upgrade -y
      
      echo "Installs ----------------------------------------------------"
      sudo apt install -y git
      sudo apt install tree -y 
      sudo apt install unzip -y
      sudo apt install -y docker.io
      sudo systemctl start docker
      sudo systemctl enable docker
      sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose      
      # sudo apt install -y nginx
      # sudo systemctl enable nginx
      # sudo systemctl start nginx

      echo "Data --------------------------------------------------------"
      mkdir -p /home/guilhermeviegas1993/data/clean_data/{munic,micro,meso,rgime,rgint,state,region}
      mkdir -p /home/guilhermeviegas1993/data/curated_data/{munic,micro,meso,rgime,rgint,state,region}
      sudo chmod -R 777 /home/guilhermeviegas1993/data/
      sudo gsutil -m cp -r gs://${var.cleanbucket_name}/* /home/guilhermeviegas1993/data/clean_data
      # sudo gsutil -m cp -r gs://${var.curatedbucket_name}/* /home/guilhermeviegas1993/data/curated_data

      echo "Setting-up git -----------------------------------------------"
      mkdir -p ~/.ssh
      chmod 700 ~/.ssh
      touch ~/.ssh/id_rsa
      chmod 600 ~/.ssh/id_rsa
      ssh-keyscan -H github.com >> ~/.ssh/known_hosts
      chmod 644 ~/.ssh/known_hosts
      eval "$(ssh-agent -s)"
      ssh-add ~/.ssh/id_rsa
      git config --global user.email "guilhermeviegas1993@gmail.com"
      git config --global user.name "Gui-go"

      # Simple UI port 80 repo -----------------------------------------------"
      sudo -u guilhermeviegas1993 git git@github.com:personalVM/simple_web80.git
      sudo git config --global --add safe.directory /home/guilhermeviegas1993/simple_web80
      docker-compose -f /home/guilhermeviegas1993/simple_web80/docker-compose.yaml up -d

      echo "Personal RStudio repo -----------------------------------------------"
      sudo -u guilhermeviegas1993 git clone git@github.com:personalVM/personal_rstudio.git /home/guilhermeviegas1993/personal_rstudio/
      sudo git config --global --add safe.directory /home/guilhermeviegas1993/personal_rstudio
      sudo env R_PASS=${data.google_secret_manager_secret_version.tf_mainsecret.secret_data} \
        docker-compose -f /home/guilhermeviegas1993/personal_rstudio/docker-compose.yml up -d --build
      # sudo env R_PASS=passwd docker-compose -f /home/guilhermeviegas1993/personal_rstudio/docker-compose.yml up -d --build
      sudo docker exec -t posit bash -c 'chown -R rstudio:rstudio /home/rstudio/volume/'
      sudo docker ps

      sudo docker exec -t posit bash -c '
        sudo apt update -y
        sudo apt install tree -y
        sudo mkdir -p ~/.ssh
        sudo echo -e "${data.google_secret_manager_secret_version.tf_secretgitprivsshk.secret_data}" > ~/.ssh/id_rsa
        sudo chmod 600 ~/.ssh/id_rsa
        sudo touch ~/.ssh/known_hosts
        sudo ssh-keyscan -H github.com > ~/.ssh/known_hosts
        sudo chmod 600 ~/.ssh/known_hosts
        eval "$(ssh-agent -s)"
        sudo ssh-add ~/.ssh/id_rsa
        sudo git config --global user.email "guilhermeviegas1993@gmail.com"
        sudo git config --global user.name "Gui-go"
        sudo git config --global --add safe.directory /home/rstudio/volume/etl/
        sudo chmod -R 777 /home/rstudio/volume/etl/
      '

      echo "ETL repo -----------------------------------------------"
      sudo mkdir -p /home/guilhermeviegas1993/etl
      sudo chown -R guilhermeviegas1993:guilhermeviegas1993 /home/guilhermeviegas1993/etl
      sudo chown -R guilhermeviegas1993:guilhermeviegas1993 /home/guilhermeviegas1993
      sudo chmod 700 /home/guilhermeviegas1993/.ssh
      sudo chmod 600 /home/guilhermeviegas1993/.ssh/id_rsa
      eval "$(ssh-agent -s)"
      sudo -u guilhermeviegas1993 ssh-add ~/.ssh/id_rsa
      sudo -u guilhermeviegas1993 ssh-keyscan -H github.com >> ~/.ssh/known_hosts
      sudo -u guilhermeviegas1993 ssh -T git@github.com
      sudo -u guilhermeviegas1993 git clone git@github.com:personalVM/etl.git /home/guilhermeviegas1993/etl/
      # sudo chown -R guilhermeviegas1993:guilhermeviegas1993 /home/guilhermeviegas1993/etl
      Rscript /home/rstudio/volume/etl/main_pipeline.R

      # echo "Geo Portfolio repo -----------------------------------------------"
      # sudo -u guilhermeviegas1993 git clone git@github.com:personalVM/geo_portfolio.git /home/guilhermeviegas1993/geo_portfolio/
      # sudo git config --global --add safe.directory /home/guilhermeviegas1993/geo_portfolio

      echo "Database repo -----------------------------------------------------"
      sudo -u guilhermeviegas1993 git clone git@github.com:personalVM/database.git /home/guilhermeviegas1993/database/
      sudo git config --global --add safe.directory /home/guilhermeviegas1993/database
      sudo env POSTGRES_USER=${data.google_secret_manager_secret_version.tf_mainuser.secret_data} \
        POSTGRES_PASSWORD=${data.google_secret_manager_secret_version.tf_mainsecret.secret_data} \
        GEOSERVER_ADMIN_USER=${data.google_secret_manager_secret_version.tf_mainuser.secret_data} \
        GEOSERVER_ADMIN_PASSWORD=${data.google_secret_manager_secret_version.tf_mainsecret.secret_data} \
        docker-compose -f /home/guilhermeviegas1993/database/docker-compose.yaml up -d

      # sudo gsutil -m cp -r /home/guilhermeviegas1993/data/curated_data/micro/* gs://personalvm-curatedbucket/micro
      # sudo gsutil -m cp -r gs://${var.curatedbucket_name}/* /home/guilhermeviegas1993/data/curated_data
      # personalvm-curatedbucket

      # tail -f /var/log/cloud-init-output.log

      echo "VM init finished!"

    EOF
  }
  service_account {
    email  = google_service_account.tf_computeinstance_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# resource "google_compute_disk" "tf_disk" {
#   name  = "additional-disk"
#   type  = "pd-ssd"
#   size  = 200
#   zone  = var.zone
# }

resource "google_service_account" "tf_computeinstance_service_account" {
  account_id   = "${var.proj_name}-serviceaccount"
  display_name = "Service account for VM to access GCS"
}

resource "google_project_iam_member" "tf_computeinstance_storageViewer_access" {
  project = var.proj_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.tf_computeinstance_service_account.email}"
}

resource "google_project_iam_member" "tf_computeinstance_storageCreator_access" {
  project = var.proj_id
  role    = "roles/storage.objectCreator"
  member  = "serviceAccount:${google_service_account.tf_computeinstance_service_account.email}"
}

