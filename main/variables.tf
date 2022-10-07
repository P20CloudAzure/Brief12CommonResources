variable "resource_group_name" {
  type    = string
  default = "brief12generalproject"
}

variable "resource_group_location" {
  type    = string
  default = "westeurope"
}

#variable pour le groupe MariaDB
variable "resource_pfx" {
  type    = string
  default = "groupbrief"
}

variable "admin_login" {
  type    = string
  default = "adminLogin1"
}

variable "database_count" {
  type    = number
  default = 10
}


#Variables pour le groupe Storage

variable "storage_account_name" {
    default = "brief12storageaccount"
    type    = string
}

variable "container_name_pfx" {
  description = "Containers Names"
  default     = "groupe"
  type        = string
}

variable "container_count" {
  description = "Number of container"
  default     = 10
  type        = number
}


# serviceBus

# variable pour le groupe service bus

variable "servicebus_name" {

  default = "brief12-ServiceBus"
  type    = string

}

# Variable des Queues 

variable "queue_count" {

  default     = 10
  type        = number
  description = "Queue number"

}

variable "queue_prod" {

  default     = "Prod"
  type        = string
  description = "Queue names"
}


variable "queue_dev" {

  default     = "Dev"
  type        = string
  description = "Queue names"
}

# Variables des autorisations

variable "autorisation_count" {

  default     = 10
  type        = number
  description = "Autorisation number"

}



# sendgrid

variable "app_domain" {
  type        = string
  description = "nom de domaine a ajouté"
}

variable "client_secret" {
  type        = string
  description = "Entrée le client secret du tenant ou vous voulez déployer l'infra."
}

variable "api_keyADMIN" {
  type        = string
  description = "Api keys admin a jouter pour l'auth a sendgrid"
}

variable "nameapi" {
  type =  string
  description = "nom de l'api qui va être crée"
}