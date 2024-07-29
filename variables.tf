variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "credentials_file" {
  description = "Path to the Service Account key file"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  default     = "gke-network"
}

variable "subnets" {
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  }))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type = map(list(object({
    range_name    = string
    ip_cidr_range = string
  })))
  description = "Secondary ranges that will be used in some of the subnets"
}

variable "gke_subnet" {
  description = "The name of the subnet to use for the GKE cluster"
  type        = string
}

variable "ip_range_pods_name" {
  description = "The name of the secondary IP range for pods"
}

variable "ip_range_services_name" {
  description = "The name of the secondary IP range for services"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
}

variable "create_service_account" {
  description = "Defines if service account specified to run nodes should be created"
  type        = bool
  default     = false
}

variable "node_pools" {
  type = list(map(string))
  description = "List of maps containing node pools"
}

variable "node_pools_oauth_scopes" {
  type = map(list(string))
  description = "Map of lists containing node oauth scopes by node-pool name"
  default = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
    ]
  }
}

variable "prefix" {
  description = "Prefix for the service account names."
  type        = string
  default     = ""
}

variable "service_accounts" {
  description = "List of service accounts to create"
  type = list(object({
    account_id   = string
    display_name = string
    roles        = list(string)
  }))
}