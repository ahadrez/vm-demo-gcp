output "vm_ip_address" {
  description = "The public IP address of the VM instance"
  value       = google_compute_address.static.address
}

output "vm_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.dev.name
}

output "region" {
  description = "The region used for the resources"
  value       = var.region
}

output "project_id" {
  description = "The GCP project used for deployment"
  value       = var.project
}