output "output_tf_rawbucket_name" {
  value = google_storage_bucket.tf_rawbucket.name
}

output "output_tf_cleanbucket_name" {
  value = google_storage_bucket.tf_cleanbucket.name
}

# output "output_tf_logbucket_name" {
#   value = google_storage_bucket.tf_logbucket.name
# }

output "output_tf_rawbucket_id" {
  value = google_storage_bucket.tf_rawbucket.id
}

output "output_tf_cleanbucket_id" {
  value = google_storage_bucket.tf_cleanbucket.id
}

# output "output_tf_logbucket_id" {
#   value = google_storage_bucket.tfgcplogbucket.id
# }




