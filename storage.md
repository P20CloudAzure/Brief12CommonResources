# Storage

## Description

 Nous avons un compte de stockage (storage account) dans lequel il y a dix conteneurs de stockage, avec à l’intérieur de chacun deux Blob qui correspondent respectivement à un environnement de **production** et un de **développement**.
Le but étant que chaque binômes puisse accéder à un conteneur  de stockage. Pour cela nous allons générer une clé d'accès partagé **(SAS)** pour chaque conteneur, qui donnera accès aux deux environnements PROD et DEV.
Le tout sera créé avec Terraform.

## Le script Terraform

sert à la création du compte de stockage.

 resource  "azurerm_storage_account"  "storage"

 sert à la création d'un conteneur à l'intérieur du compte de stockage.

  resource  "azurerm_storage_container"  "container"
 sert à la création du répertoire  dev dans le conteneur.

 resource  "azurerm_storage_blob"  "dev"
sert à la création du répertoire prod dans le conteneur.

 resource  "azurerm_storage_blob"  "prod"
sert à générer la clé d'accès partagé (SAS) de chacun des conteneurs.

 data  "azurerm_storage_account_blob_container_sas"  "sas_key_gen"
sert à récupérer les clés SAS depuis Azure.

 output  "sas_url_query_string"

sert au stockage en local de nos clés SAS dans un fichier.

 resource  "local_sensitive_file"  "cles_sas"

## Le résultat

En sortie, nous avons des liens https qui donnent accès à nos dix conteneurs.

'https://<nom_compte_stockage>.blob.core.windows.net/<nom_conteneur><cle_sas' // Voilà à quoi correspond les valeurs du lien
