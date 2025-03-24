terraform {
  required_version = ">= 1.10.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.90.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.36.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.17.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }

  }
}
