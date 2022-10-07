# Documentation database mariadb

## Sommaire
>- Objectifs
>- Graph
>- Definition des providers
>- Ressources communes
>- Ressources database
>- Ressources diverses
>- Get it started

---
## Objectif
- Mise en place d'un serveur de base de données MariaDB via Terraform avec
    - 10 bases de données DEV et 10 base de données PROD 
    - avec chacune un utilisateur, un mot de passe propre et priviléges exclusifs

---
## Graph des dépendances
![graphDB.png](/mariadb/images/graphDB.png)

---
## Definition des providers

- azurerm = requis pour ressources azure
    - source  = "hashicorp/azurerm"
    - version = "3.21.1"

- random = requis pour passwords aléatoires
    - source  = "hashicorp/random"
    - version = ">= 3.4.3"

- mysql = requis pour creation des users et privileges sur base de données mariadb
    - source  = "petoju/mysql"
    - version = "3.0.20"

- local = requis pour generer fichier local
    - source = "hashicorp/local"
    - version = "2.2.3"

- http = download data http
    - source = "hashicorp/http"
    - version = "3.1.0"

---
## Ressources communes
- resource "azurerm_resource_group" "p20cloud" &rarr; création du groupe azure Brief12CommonResources

---
## Ressources mysql

- resource "azurerm_mariadb_server" "p20cloud"  &rarr; création du serveur mysql
    - avec ssl

- resource "azurerm_mariadb_firewall_rule" x 2  &rarr; régle de firewall accés service azure et ip admin determiné

- resource "azurerm_mariadb_database" x 2  &rarr; création des 10 databases dev et prod
    - utilisation de boucle count

- resource "mysql_user" x 2  &rarr; création des users de databases dev et prod
    - utilisation de boucle count

- resource "mysql_grant" x 2  &rarr; gestion des priviléges sur database pour chaque user dev et prod
    - utilisation de boucle count

---
## Ressources diverses

- resource "random_string" &rarr; generation de password complexe
- resource "null_resource" pour execution de commande shell avec provisioner "local-exec"
- data "http" "myip"  &rarr; pour récuperation ip de l'executant du script terraform via url = "http://ifconfig.me/ip"
- data "http" "downloadcert"  &rarr; pour récuperation certificat via url = "https://cacerts.digicert.com/BaltimoreCyberTrustRoot.crt.pem"
- resource "local_file" "export" x 2 &rarr; alternative au provisioner "local-exec" pour generer fichiers locaux d'infos et certificat
    - parsing du content à l'aide d'une boucle for et de conditions basées sur l'index du dbpassword
    - l'index 0 etant le password admin
    - les index <= 10 étant les logins dev
    - les autres étant les logins prod

---
## Get it started
```bash
terraform init
terraform plan
terraform apply --auto-approve
```
- un fichier mariadb.txt est généré avec les informations de login, password et database.
- un certificat ssl mycert.crt.pem est généré localement
- pour se connecter au serveur mariadb en ligne de commande entrer la commande suivante dans le terminal:

`mysql --user=<nom utilisateur> --password=<password> --host=<nom du serveur mariadb>.mariadb.database.azure.com --ssl-ca=<nom du certificat>`
