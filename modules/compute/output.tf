output "tf_iip" {
  value = google_compute_instance.tf_vm.network_interface[0].access_config[0].nat_ip
}
