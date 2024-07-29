output "network_name" {
  description = "The name of the VPC being created"
  value       = module.vpc.network_name
}

output "subnet_name" {
  description = "The name of the subnet being created"
  value       = module.vpc.subnets_names[0]
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  sensitive   = true
  value       = module.gke.endpoint
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster"
  sensitive   = true
  value       = module.gke.ca_certificate
}

output "service_account_emails" {
  description = "The emails of the created service accounts."
  value = {
    for k, v in google_service_account.service_accounts : k => v.email
  }
}
