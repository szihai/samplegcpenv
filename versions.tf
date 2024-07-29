terraform {
  required_version = ">= 0.13"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  #credentials = var.credentials_file
}

provider "google-beta" {
  project     = var.project_id
  region      = var.region
  #credentials = var.credentials_file
}