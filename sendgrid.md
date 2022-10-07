# <img src="https://cdn.discordapp.com/attachments/970972759326851082/1027224586674249728/twilio_sendgrid_logo.png"> Documentation sendgrid

## Sommaire

- Objectifs
- Graph
- providers
- Ressources
- Creation en GUI
- Get it started

* * *

## Objectif

- Create a domain name and sendgrid service
    - useing the domain name
    - using the API

* * *

## Dependency graph

![sggraph.png](/images/sggraph.png)

* * *

## Definition of providers

- azurerm = required_providers

    - source = "hashicorp/azurerm"
    - version = ">= 3.23.0"
        -sendgrid
    - source = "Trois-Six/sendgrid"
    - version = "= 0.2.1"

## Common resources

- resource "azurerm_resource_group" "p20cloud" → creation the resource group
- resource "azurerm_dns_zone" "p20cloud" → creation the dns zone
- resource "sendgrid_domain_authentication" "p20cloud" →authentication the domain name
- resource "azurerm_dns_txt_record" "p20cloud" →Automated Security
- resource "azurerm_dns_mx_record" "p20cloud" →Automated Security

* * *

## Création en GUI

### buying a domain name

![sg1](/images/sg1.png)

### creating the app service domain

![sg2](/images/sg2.png)

### then full all of the important informations

![sg3](/images/sg3.png)

##### and then create the app service domain

##### after creating the domain it will show us this page so we have to click on manage DNS records

![sg5](/images/sg5.png)

##### after that it will show us the follwing page so we have to click on Record set

![sg6](/images/sg6.png)

##### and to use this we have to link it with another service called **Twilio SendGrid** you can find it in azure marketplace

![sg7](/images/sg7.png)

### then go to the resource group and open SaaS Account on publisher’s site and connect with your azure acount to show sendgrid page

![sg8](/images/sg8.png)

#### go to the settind

![sg9](/images/sg9.png)

### and then choose Sender Authentication

![sg10](/images/sg10.png)

### choose then authenticate Your Domain

![sg11](/images/sg11.png)

### for the DNS host select other host

### and for which DNS host you have to go back to the app service domain and to take the domain name which you have created it and put here

#### after that it will show for us the following page so what we have to do is to copy all of the host and values and put it in the app service domain all of them

![sg12](/images/sg12.png)

### click on Record set and then copy the host from sendgrid in the name box in the type you have to choose CNAME in the ALIAS box put the value of the sendgrid sender authentication repeat this three times with all of the host and the values and then click ok and that's it

![sg13](/images/sg13.png)


* * *

## Get it started

`terraform init`
`terraform plan`
`terraform apply --auto-approve`

