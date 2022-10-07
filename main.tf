
# Creation d'un groupe de ressource

resource "azurerm_resource_group" "p20cloud" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


# sendgrid

#récupération des info du ressources groupe déja crée .
data "azurerm_resource_group" "resourcegroup" {
  name = var.resource_group_name
}

#récupération des info de la zone dns .
data "azurerm_dns_zone" "dnsZone" {
  name                = var.app_domain
  resource_group_name = var.resource_group_name
}

#création d'une authentification de domaine pour valider le nom de domaine crée au préalable.
resource "sendgrid_domain_authentication" "groupgriddomain" {
  domain             = "brief12engrid.org"
  is_default         = true
  automatic_security = false
}



#Création de 3 dns record que l'authenfication va utiliser dont deux sous le format txt (automated security on) et une sous le format mx (automated security).
resource "azurerm_dns_txt_record" "cname1" {
  name                = trimsuffix(sendgrid_domain_authentication.groupgriddomain.dns[0].host, ".${data.azurerm_dns_zone.dnsZone.name}")
  zone_name           = "${data.azurerm_dns_zone.dnsZone.name}"
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  depends_on = [sendgrid_domain_authentication.groupgriddomain]


  record {
    value = var.app_domain
  }

}

#Création d'un dns record que l'authenfication va utiliser sous le format txt.
resource "azurerm_dns_txt_record" "cname2" {
  name                = trimsuffix(sendgrid_domain_authentication.groupgriddomain.dns[1].host, ".${data.azurerm_dns_zone.dnsZone.name}")
  zone_name           = "${data.azurerm_dns_zone.dnsZone.name}"
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  depends_on = [sendgrid_domain_authentication.groupgriddomain]


  record {
    value = var.app_domain
  }

}

#Création d'un dns record que l'authenfication va utiliser sous le format mx .
resource "azurerm_dns_mx_record" "cname3" {
  name                = trimsuffix(sendgrid_domain_authentication.groupgriddomain.dns[2].host, ".${data.azurerm_dns_zone.dnsZone.name}")
  zone_name           = "${data.azurerm_dns_zone.dnsZone.name}"
  resource_group_name = var.resource_group_name
  ttl                 = 3600
  depends_on = [sendgrid_domain_authentication.groupgriddomain]


 record {
    preference = 20
    exchange   = "brief12engrid.org"
  }
}