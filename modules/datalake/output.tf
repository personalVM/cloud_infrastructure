output "rawbucket_name" {
  value = google_storage_bucket.tf_rawbucket.name
}

output "cleanbucket_name" {
  value = google_storage_bucket.tf_cleanbucket.name
}

output "rawbucket_id" {
  value = google_storage_bucket.tf_rawbucket.id
}

output "cleanbucket_id" {
  value = google_storage_bucket.tf_cleanbucket.id
}
