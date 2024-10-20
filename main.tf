locals {
  proj_name    = "personalvm"
  proj_id      = "personalvm1"
  location     = "us-west4" #us-west4
  zone         = "us-west4-b"
  tag_owner    = "guilhermeviegas"
}

module "network" {
  source    = "./modules/network"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  location  = local.location
  zone      = local.zone
  tag_owner = local.tag_owner
}

module "datalake" {
  source    = "./modules/datalake"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  location  = "US" # local.location
  tag_owner = local.tag_owner
}

module "compute" {
  source            = "./modules/compute"
  proj_name         = local.proj_name
  proj_id           = local.proj_id
  location          = local.location
  zone              = local.zone
  machine_type      = "n1-standard-4"
  tag_owner         = local.tag_owner
  network_name      = module.network.vpc_network_name
  static_ip_address = module.network.static_ip_address
  cleanbucket_name  = module.datalake.cleanbucket_name
  gpu_enabled       = false
}

# module "compute2" {
#   source           = "./modules/compute"
#   proj_name        = local.proj_name
#   proj_id          = local.proj_id
#   svc_name         = "vm2"
#   location         = local.location
#   zone             = local.zone
#   machine_type     = "n1-standard-4"
#   tag_owner        = local.tag_owner
#   network_name     = module.network.vpc_network_name
#   cleanbucket_name = module.datalake.output_tf_cleanbucket_name
#   gpu_enabled      = false
# }

# module "compute3" {
#   source           = "./modules/compute"
#   proj_name        = local.proj_name
#   proj_id          = local.proj_id
#   svc_name         = "vm3"
#   location         = "europe-west4"
#   zone             = "europe-west4-b"
#   machine_type     = "n1-standard-4"
#   tag_owner        = local.tag_owner
#   network_name     = module.network.vpc_network_name
#   cleanbucket_name = module.datalake.output_tf_cleanbucket_name
#   gpu_enabled      = true
#   gpu_type         = "nvidia-tesla-p4"
# }


# module "management" {
#   source    = "./modules/management"
#   proj_name = local.proj_name
#   proj_id   = local.proj_id
#   location  = local.location
#   tag_owner = local.tag_owner
#   dataplex_lake_name = "dataplexlakename1"
#   raw_data_bucket_name = "${local.proj_name}-rawbucket"
#   clean_data_bucket_name = "${local.proj_name}-cleanbucket"
#   raw_data_bucket_id = module.datalake.output_tf_rawbucket_id
#   clean_data_bucket_id = module.datalake.output_tf_cleanbucket_id
# }


