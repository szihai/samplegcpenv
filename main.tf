module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 31.0"

  project_id              = var.project_id
  name                    = var.cluster_name
  #for demo purpose
  deletion_protection     = false

  region                  = var.region
  network                 = module.vpc.network_name
  subnetwork              = var.gke_subnet
  ip_range_pods           = var.ip_range_pods_name
  ip_range_services       = var.ip_range_services_name
  node_pools              = var.node_pools
  node_pools_oauth_scopes = var.node_pools_oauth_scopes

  depends_on              = [module.vpc]
}
