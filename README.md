# Sample GCP Environment Terraform Configuration

This Terraform module provisions a Google Cloud Platform (GCP) environment, including a Virtual Private Cloud (VPC), Service Accounts and a Google Kubernetes Engine (GKE) cluster, using official Hashicorp and Google joint maintained Terraform modules. It supports flexible service accounts, subnets, and node pools configuration.

## Prerequisites

1. A GCP project created with billing enabled.
2. Terraform installed on your local machine (Latest version).
3. Gcloud installed and configured.
4. GCP service APIs enabled on the GCP project. The minimum apis needed are container.googleapis.com and compute.googleapis.com.

## Usage

* Clone this repository to your local machine.
* Navigate to the configuration directory:

  ```
  cd path/to/repo
  ```
* Create a `terraform.tfvars` file in the same directory and add your specific values. There is a terraforms.tfvars.sample for you reference.
* If you plan to use a GCP Service Account to run the terraform configuration, here are the steps. Otherwise skip this step:

  * Download the Service Account key to a json file.
  * Uncomment the two lines (#14 and #20) in versions.tf:

    ```
    credentials = var.credentials_file
    ```
  * Export the json key file:
    `export TF_VAR_credentials_file="path to your key file"`
* Initialize Terraform:

  ```
  terraform init
  ```
* Review the planned changes:

  ```
  terraform plan
  ```
* Apply the changes:

  ```
  terraform apply
  ```
* Confirm by typing `yes` when prompted.

## Inputs

| Variable Name           | Description                                                         | Type              |
| ----------------------- | ------------------------------------------------------------------- | ----------------- |
| project_id              | The project ID to host the cluster in                               | string            |
| region                  | The region to host the cluster in                                   | string            |
| credentials_file        | Path to the Service Account key file                                | string            |
| network_name            | The name of the VPC network                                         | string            |
| subnets                 | The list of subnets being created                                   | list(object)      |
| secondary_ranges        | Secondary ranges that will be used in some of the subnets           | map(list(object)) |
| gke_subnet              | The name of the subnet to use for the GKE cluster                   | string            |
| ip_range_pods_name      | The name of the secondary IP range for pods                         | string            |
| ip_range_services_name  | The name of the secondary IP range for services                     | string            |
| cluster_name            | The name of the GKE cluster                                         | string            |
| create_service_account  | Defines if service account specified to run nodes should be created | bool              |
| node_pools              | List of maps containing node pools                                  | list(map(string)) |
| node_pools_oauth_scopes | Map of lists containing node oauth scopes by node-pool name         | map(list(string)) |
| prefix                  | Prefix for the service account names                                | string            |
| service_accounts        | List of service accounts to create                                  | list(object)      |

## Flexibility in configuration

You can customize various aspects of the VPC and GKE cluster by modifying the variables in `terraform.tfvars`. The configuration now supports:

- Multiple subnets with different CIDRs
  Here is an example:

  ```
    subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/29"
      subnet_region = "us-west1"
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = "us-west2"
    }
    ]
  ```

  Not only the subnets, but the secondaries of each subnet can also have different multiple cidrs. And because of that, in the GKE module, the subnets and secondary ranges are variables needed to be specified as there are multiple possibilities.
- Multiple node pools with different configurations
  Here is an example:

  ```
    node_pools= [
        {
        name               ="default-node-pool"
        machine_type       ="e2-medium"
        min_count          =1
        max_count          =10
        initial_node_count =3
        autoscaling        =true
        },
        {
        name               ="high-cpu-pool"
        machine_type       ="c2-standard-8"
        min_count          =0
        max_count          =5
        initial_node_count =0
        autoscaling        =true
        }

      ]
  ```
- Autoscaling
  The autoscaling is supported at the nodepool level. Becasue the nodepools in this cluster can have different configurations, if we enable the autoscaling at cluster level, the cluster's decision to scale the nodepools may not land on the most suitable nodepool candidate. By using the nodepool level autoscaling, we can ensure the autoscaling happens at the suitable nodepool. The variables needed at each nodepool, as shown in above example, are `min_count`, `max_count `and `initial_node_count`. The nodepool `autoscaling` switch is by default set to true.
- Multi Service Accounts
  The service accounts module can support different IAM role bindings. Here is an example:

  ```
  service_accounts = [
    {
      account_id   = "cluster-admin"
      display_name = "GKE cluster admin"
      roles        = [
        "roles/compute.networkAdmin",
        "roles/container.clusterAdmin",
        "roles/compute.viewer"
      ]
    },
    {
      account_id   = "cluster-dev"
      display_name = "GKE cluster user"
      roles        = [
        "roles/container.developer",
        "roles/storage.objectViewer",
        "roles/monitoring.viewer",
        "roles/logging.viewer"
      ]
    }
  ]
  ```
Again, all the flexible configurations are supported by changing the values of the variables. No code change is involved.

## Outputs

After applying the Terraform configuration, you can use the following outputs:

- `network_name`: The name of the created VPC network
- `subnet_names`: The names of the created subnets
- `cluster_name`: The name of the created GKE cluster
- `cluster_endpoint`: The IP address of the cluster master (sensitive value)
- `cluster_ca_certificate`: The public certificate that is the root of trust for the cluster (sensitive value)
- `Service_accounts_emails`: The emails of the created service accounts

## Cleanup

To remove all resources created by this configuration, run:

```

terraform destroy

```

Confirm by typing `yes` when prompted.

```

```
