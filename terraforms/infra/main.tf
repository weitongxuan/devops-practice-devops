
data "azurerm_resource_group" "this" {
  name = "rg-devops-dev-001"
}

data "azurerm_container_registry" "acr" {
  name                = "devopstestcr1.azurecr.io"
  resource_group_name = "rg-devops-dev-001"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "example-aks1"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = "devops-practice"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2ms"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "helm_release" "ingress" {
  name             = "nginx-ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
}


resource "azurerm_storage_account" "example" {
  name                     = "devopsteststoragelinker"
  location                 = data.azurerm_resource_group.this.location
  resource_group_name      = data.azurerm_resource_group.this.name
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
