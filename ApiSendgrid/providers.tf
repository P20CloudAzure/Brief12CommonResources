terraform {
  required_providers {
    sendgrid = {
      source  = "Trois-Six/sendgrid"
      version = "0.2.1"
    }
  }
}

provider "sendgrid" {
  api_key = var.api_keyADMIN
  # Configuration options
}