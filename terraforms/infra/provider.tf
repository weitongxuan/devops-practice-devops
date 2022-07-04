provider "azurerm" {
  features {}

  client_id       = "2ece286a-ffcc-4e96-9e01-2359c9e3c81b"
  client_secret   = "LFS8Q~ilUxGeuLPNSW_z14UjwTROs-booAhqAcxP"
  tenant_id       = "2cf4248e-4836-4202-b796-9a1589ff4613"
  subscription_id = "091725d9-aeba-4638-8faf-d0e81a03a93d"
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-devops-dev-001"
    storage_account_name = "linkerterraformstates"
    container_name       = "practice"
    key                  = "terraform.tfstate"
    client_id            = "2ece286a-ffcc-4e96-9e01-2359c9e3c81b"
    client_secret        = "LFS8Q~ilUxGeuLPNSW_z14UjwTROs-booAhqAcxP"
    tenant_id            = "2cf4248e-4836-4202-b796-9a1589ff4613"
    subscription_id      = "091725d9-aeba-4638-8faf-d0e81a03a93d"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
