
# Création d'un service Bus


resource "azurerm_servicebus_namespace" "servicebusGroup" {
  depends_on          = [azurerm_resource_group.p20cloud]
  name                = var.servicebus_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}


# Création des queues 

# Queue de Prod

resource "azurerm_servicebus_queue" "Prod_servicebus_queue" {

  count = var.queue_count
  depends_on = [azurerm_servicebus_namespace.servicebusGroup]
  name         = "${var.queue_prod}-${count.index}"
  namespace_id = azurerm_servicebus_namespace.servicebusGroup.id

  enable_partitioning = true

}

# Queue de DEV

resource "azurerm_servicebus_queue" "Dev_servicebus_queue" {

  count = var.queue_count
  depends_on = [azurerm_servicebus_namespace.servicebusGroup]
  name         = "${var.queue_dev}-${count.index}"
  namespace_id = azurerm_servicebus_namespace.servicebusGroup.id

  enable_partitioning = true

}


# Création des autorisations

resource "azurerm_servicebus_queue_authorization_rule" "autorisationProd" {

   count = var.autorisation_count
   depends_on = [azurerm_servicebus_queue.Prod_servicebus_queue]

  name     = "autorisationProd${count.index}"
  queue_id = azurerm_servicebus_queue.Prod_servicebus_queue[count.index].id

  listen = true
  send   = true
  manage = true
}


resource "azurerm_servicebus_queue_authorization_rule" "autorisationDev" {

    count = var.autorisation_count
   depends_on = [azurerm_servicebus_queue.Dev_servicebus_queue]
  name     = "autorisationDev${count.index}"
  queue_id = azurerm_servicebus_queue.Dev_servicebus_queue[count.index].id

  listen = true
  send   = true
  manage = true
}


# Récupération des informations de l'nvironnement de developpement

data "azurerm_servicebus_queue_authorization_rule" "autorisationDev" {

  count = var.queue_count
  depends_on = [azurerm_servicebus_queue_authorization_rule.autorisationDev]
  name                ="autorisationDev${count.index}"
  resource_group_name = var.resource_group_name
  queue_name          = "${var.queue_dev}-${count.index}"
  namespace_name      = var.servicebus_name
}


# Récupération des informations de l'nvironnement de production.

data "azurerm_servicebus_queue_authorization_rule" "autorisationProd" {

  count = var.queue_count
  depends_on = [azurerm_servicebus_queue_authorization_rule.autorisationProd]
  name                ="autorisationProd${count.index}"
  resource_group_name = var.resource_group_name
  queue_name          = "${var.queue_prod}-${count.index}"
  namespace_name      = var.servicebus_name
}



resource "local_sensitive_file" "Dev" {
  content  = yamlencode(data.azurerm_servicebus_queue_authorization_rule.autorisationDev[*])
  filename = "dev_data.txt"
}

resource "local_sensitive_file" "Prod" {
  content  = yamlencode(data.azurerm_servicebus_queue_authorization_rule.autorisationProd[*])
  filename = "prod_data.txt"
}
