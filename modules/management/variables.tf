variable "proj_name" {
  description = "Project name identifier"
  type        = string
}

variable "proj_id" {
  description = "Project ID identifier"
  type        = string
}

variable "location" {
  description = "Location of the resources"
  type        = string
  default     = "us-central1"
}

variable "tag_owner" {
  description = "Owner identifier"
  type        = string
  default     = "GuilhermeViegas"
}

variable "dataplex_lake_name" {
  description = "The name of the Dataplex lake."
  type        = string
}

variable "raw_data_bucket_name" {
  description = "The name of the Cloud Storage bucket for raw data."
  type        = string
}

variable "clean_data_bucket_name" {
  description = "The name of the Cloud Storage bucket for clean data."
  type        = string
}

variable "raw_data_bucket_id" {
  description = "The id of the Cloud Storage bucket for raw data."
  type        = string
}

variable "clean_data_bucket_id" {
  description = "The id of the Cloud Storage bucket for clean data."
  type        = string
}
