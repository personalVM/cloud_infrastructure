variable "proj_name" {
  description = "Project name"
  type        = string
}

variable "proj_id" {
  description = "Project ID identifier"
  type        = string
}

variable "svc_name" {
  description = "Service name"
  type        = string
}

variable "location" {
  description = "Location of the resources"
  type        = string
}

variable "zone" {
  description = "Zone of the resources"
  type        = string
}

variable "machine_type" {
  description = "Virtual Machine type/size"
  type        = string
}

variable "tag_owner" {
  description = "Tag to describe the owner of the resources"
  type        = string
}

variable "network_name" {
  description = "Output from network module"
  type        = string
}

variable "cleanbucket_name" {
  description = "Name of the Cloud Storage Clean Bucket"
  type        = string
}

variable "gpu_enabled" {
  description = "Whether to enable GPU"
  type        = bool
  default     = false
}

variable "gpu_type" {
  description = "Which GPU to use"
  type        = string
  default     = "nvidia-tesla-t4"
}



