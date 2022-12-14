# Creation mysql server

resource "azurerm_mariadb_server" "p20cloud" {
  name                = "${var.resource_pfx}mariadb"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  sku_name = "GP_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = var.admin_login
  administrator_login_password = random_password.dbpassword[0].result
  version                      = "10.2"
  ssl_enforcement_enabled      = true

  depends_on = [azurerm_resource_group.p20cloud, random_password.dbpassword]
}

#######################################################################
# Creation régles firewall

resource "azurerm_mariadb_firewall_rule" "p20cloud" {
  name                = "office_rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mariadb_server.p20cloud.name
  start_ip_address    = data.http.myip.body
  end_ip_address      = data.http.myip.body

  depends_on = [azurerm_mariadb_server.p20cloud]
}

resource "azurerm_mariadb_firewall_rule" "p20cloud2" {
  name                = "allow_access"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mariadb_server.p20cloud.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"

  depends_on = [azurerm_mariadb_server.p20cloud]
}

#######################################################################
# Creation de base de données mysql

resource "azurerm_mariadb_database" "p20clouddev" {
  name                = "${var.resource_pfx}dev${format("%02d", count.index + 1)}"
  resource_group_name = var.resource_group_name
  count               = var.database_count
  server_name         = azurerm_mariadb_server.p20cloud.name
  charset             = "utf8"
  collation           = "utf8_unicode_520_ci"


  depends_on = [azurerm_mariadb_firewall_rule.p20cloud]
}
resource "azurerm_mariadb_database" "p20cloudprod" {
  name                = "${var.resource_pfx}prod${format("%02d", count.index + 1)}"
  resource_group_name = var.resource_group_name
  count               = var.database_count
  server_name         = azurerm_mariadb_server.p20cloud.name
  charset             = "utf8"
  collation           = "utf8_unicode_520_ci"


  depends_on = [azurerm_mariadb_firewall_rule.p20cloud]
}

#######################################################################
# Creation des users du serveur mysql

resource "mysql_user" "p20clouddev" {
  user               = "${var.resource_pfx}devuser${format("%02d", count.index + 1)}"
  host               = "%"
  plaintext_password = random_password.dbpassword[count.index + 1].result
  count              = var.database_count

  depends_on = [azurerm_mariadb_firewall_rule.p20cloud, random_password.dbpassword]
}
resource "mysql_user" "p20cloudprod" {
  user               = "${var.resource_pfx}produser${format("%02d", count.index + 1)}"
  host               = "%"
  plaintext_password = random_password.dbpassword[count.index + 11].result
  count              = var.database_count

  depends_on = [azurerm_mariadb_firewall_rule.p20cloud, random_password.dbpassword]
}

#######################################################################
# Ajout des privileges aux users db mysql

resource "mysql_grant" "p20clouddev" {
  user       = "${var.resource_pfx}devuser${format("%02d", count.index + 1)}"
  host       = "%"
  database   = "${var.resource_pfx}dev${format("%02d", count.index + 1)}"
  privileges = ["SELECT", "UPDATE", "DELETE", "EXECUTE", "INSERT", "CREATE"]
  count      = var.database_count

  depends_on = [mysql_user.p20clouddev, azurerm_mariadb_database.p20clouddev]
}

resource "mysql_grant" "p20cloudprod" {
  user       = "${var.resource_pfx}produser${format("%02d", count.index + 1)}"
  host       = "%"
  database   = "${var.resource_pfx}prod${format("%02d", count.index + 1)}"
  privileges = ["SELECT", "UPDATE", "DELETE", "EXECUTE", "INSERT", "CREATE"]
  count      = var.database_count

  depends_on = [mysql_user.p20cloudprod, azurerm_mariadb_database.p20cloudprod, mysql_grant.p20clouddev]
}

#######################################################################
# Creation des passwords

resource "random_password" "dbpassword" {
  length  = 20
  special = false
  count   = (var.database_count * 2) + 1
}

#######################################################################
# Export du certificat

resource "local_file" "mycert" {
  content  = data.http.downloadcert.body
  filename = "mycert.crt.pem"
}


# Export des infos user, db et certificat
# parsing des infos à l'aide d'une boucle for et de conditions basées sur l'index du dbpassword
resource "local_sensitive_file" "export" {
  depends_on = [random_password.dbpassword]
  content = yamlencode(
    [for elem in random_password.dbpassword[*].result :
      index(random_password.dbpassword[*].result, elem) == 0 ?
      "server = ${var.resource_pfx}mariadb.mariadb.database.azure.com   certificat = mycert.crt.pem   admin-login = ${var.admin_login}   admin-password = ${random_password.dbpassword[0].result}" :
      index(random_password.dbpassword[*].result, elem) <= 10 ?
      "login = ${var.resource_pfx}devuser${format("%02d", index(random_password.dbpassword[*].result, elem))}   password = ${elem}   database = ${var.resource_pfx}dev${format("%02d", index(random_password.dbpassword[*].result, elem))}" :
      "login = ${var.resource_pfx}produser${format("%02d", index(random_password.dbpassword[*].result, elem) - 10)}   password = ${elem}   database = ${var.resource_pfx}prod${format("%02d", index(random_password.dbpassword[*].result, elem) - 10)}"
    ]
  )
  filename = "mariadb.txt"
}