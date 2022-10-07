# Création du storage account

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.p20cloud.name
  location                 =azurerm_resource_group.p20cloud.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Création des 10 Blob container
resource "azurerm_storage_container" "container" {
  count                 = var.container_count # Count Value read from variable
  depends_on            = [azurerm_storage_account.storage]
  name                  = "${var.container_name_pfx}-${count.index}"
  storage_account_name  = var.storage_account_name
  container_access_type = "blob"
}

# Création du dossier dev dans les 10 blob container
resource "azurerm_storage_blob" "dev" {
  count = var.container_count
  depends_on             = [azurerm_storage_container.container]
  name                   = "dev/"
  storage_account_name   = var.storage_account_name
  storage_container_name = "${var.container_name_pfx}-${count.index}"
  type                   = "Block"
}

# Création du dossier prod dans les 10 blob container
resource "azurerm_storage_blob" "prod" {
  count = var.container_count
  depends_on             = [azurerm_storage_container.container]
  name                   = "prod/"
  storage_account_name   = var.storage_account_name
  storage_container_name = "${var.container_name_pfx}-${count.index}"
  type                   = "Block"
}

# Création de la clé SAS de chaque container
data "azurerm_storage_account_blob_container_sas" "sas_key_gen" {
  count             = var.container_count
  depends_on        = [azurerm_storage_container.container]
  connection_string = azurerm_storage_account.storage.primary_connection_string
  container_name    = "${var.container_name_pfx}-${count.index}"
  https_only        = true

  start  = "2022-09-26"
  expiry = "2022-11-21"

  permissions {
    read   = true
    add    = true
    create = false
    write  = false
    delete = true
    list   = true
  }

  cache_control       = "max-age=5"
  content_disposition = "inline"
  content_encoding    = "deflate"
  content_language    = "fr-FR"
  content_type        = "application/json"
}

# Sauvegarde dans un fichier local des clés SAS de nos containers
resource "local_sensitive_file" "cles_sas" {
  content  =  yamlencode(data.azurerm_storage_account_blob_container_sas.sas_key_gen[*])
  filename = "sas_keys.txt"
}
