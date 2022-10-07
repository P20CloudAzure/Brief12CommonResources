# <p align="center"><img src="https://img.icons8.com/fluency/48/000000/azure-1.png"/> Azure common resources with Terraform<img src="https://img.icons8.com/fluency/48/000000/terraform.png"/></p>

## Brief 12 - Partie 1 - un cloud pour la communauté

### Automatisation de la création de service bus, base de données, container de stockage et service mail via Terraform. 

Ce projet prépare les ressources pour chaque binôme de la partie 2 du brief,  il y en aura 10.
De ce fait les ressources suivantes seront générées :

* [10 queues de PROD et 10 queues de DEV dans le service bus](serviceBus.md)
* [10 bases de données de PROD et 10 base de données DEV avec chacune un utilisateur et un mot de passe propre](mariadb.md)
* [10 container de stockage contenant chacun un répertoire PROD et DEV](storage.md)
* [1 service d'envoi de MAIL Send Grid correctement configuré.](sendgrid.md)


---
### <p align="center">![diagram](/mariadb/images/diagramv1.jpg)</p>

---
### <img src="https://img.icons8.com/cotton/40/000000/settings--v1.png"/>	Guide d'installation

- Prerequis :

	- avoir installé terraform [guide d'installation](https://learn.hashicorp.com/tutorials/terraform/install-cli)

	- pouvoir se connecter via Azure cli avec `az login` [guide de connexion](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)

	- pour Sendgrid, avoir un Service Principal pour l'achat du dns. [Creer un service principal azure](https://learn.microsoft.com/fr-fr/azure/active-directory/develop/howto-create-service-principal-portal)


1. cloner ce repos : 
	- `git clone https://github.com/P20CloudAzure/Brief12CommonResources.git`
2. Se rendre dans le dossier Brief12CommonResources
3. S'assurer que les variables correspondent à vos besoins dans le fichier variables.tf
4. Puis entrer les commandes terraform suivantes dans votre terminal, pour initialiser terraform, planifier et appliquer le plan:
	- `terraform init`  
	- `terraform plan`
	- `terraform apply --auto-approve`

5. Après quelques minutes vos ressources auront été crées et votre dossier brief12CommonResources contiendra les fichiers d'informations supplémentaire suivants:
	- mariadb.txt (contient nom logins et pass utilisateurs mariadb )
	- mycert.crt.pem (certificat ssl pour la base de données)
	- storage.txt (contient clés sas storage)
	- servicebus.txt (contient chaine de connexion pour les queues)
	- sendgrid.txt (contient clé api)
	
6. Les ressources sont à votre disposition, pour plus de details, merci de suivre les liens vers les readme specifiques à chaque ressource, disponibles  un peu plus haut.

---
### <img src="https://img.icons8.com/external-smashingstocks-outline-color-smashing-stocks/45/000000/external-interactive-networking-smashingstocks-outline-color-smashing-stocks.png"/>Utilisation

**MariaDB Server** est un système de gestion de base de données relationnelle open source.
MariaDB Server peut être utilisé pour gérer des données transactionnelles à haute disponibilité, pour l’analyse de données ou comme serveur embarqué. MariaDB Server est supporté par une large gamme d’outils et d’applications.
>- les informations de connexion à la base de données sont contenues dans le fichier généré localement mariadb.txt.
>- pour se connecter au serveur mariadb en ligne de commande entrer la commande suivante dans le terminal:
>`mysql --user=<nom utilisateur> --password=<password> --host=<nom du serveur mariadb>.mariadb.database.azure.com --ssl-ca=<nom du certificat>`
>- [mariadb.md](mariadb.md)

**Storage Azure** est une solution de stockage cloud de Microsoft pour les scénarios de stockage de données actuels, il offre un stockage hautement disponible, hautement évolutif, durable et sécurisé pour divers objets de données du cloud.
>- Les objets de données du Stockage Azure sont accessibles depuis n’importe où dans le monde via http ou https via une API REST. 
>- Le portail Azure et l’Explorateur Stockage Azure fournissent des outils d’interface utilisateur pour l’interaction avec le Stockage Azure.
>- les clés SAS de connection et lien vers les conteneurs sont disponible dans le fichier storage.txt:
>`https://<nom_compte_stockage>.blob.core.windows.net/<nom_conteneur><cle_sas>`
>- [storage.md](storage.md)

**Service Bus Azure** est un répartiteur de messages d’entreprise complètement managé, avec des files d’attente de messages et des rubriques de publication/d’abonnement (dans un espace de noms). Service Bus est utilisé pour découpler les applications et les services les uns des autres pour offrir les avantages suivants :
- Travail d’équilibrage de charge entre les workers concurrents
- Routage et transfert de façon sécurisée des données et du contrôle au-delà des limites des services et des applications
- Coordination du travail transactionnel qui nécessite un degré élevé de fiabilité
>- Les autorisations pour chaque queue crées pour "send" et "listen" sont dans le fichier serviceBus.txt.
>- [serviceBus.md](serviceBus.md)

**SendGrid Twilio** est à l’origine un SMTP et une API de messagerie transactionnelle conçus pour les développeurs. Cependant, ils offrent maintenant aussi des fonctions de marketing par email.
SendGrid dispose d’une période d’essai gratuite de 30 jours au cours de laquelle vous pouvez envoyer jusqu’à 40 000 emails. Après cela, vous pouvez continuer l’essai gratuit pour toujours et envoyer jusqu’à 100 emails par jour.
Mais vous pouvez également passer à un plan supérieur pour économiser plus d’argent.
Quelques avantages supplémentaires incluent :
- Possibilité d’utiliser l’API Web ou SMTP pour envoyer des e-mails. L’API Web est plus rapide et comprend des fonctionnalités de gestion des désinscriptions d’utilisateurs, de gestion des adresses IP, de création de modèles d’emails, etc.
- Améliorez les taux de délivrabilité pour atteindre les boîtes de réception des utilisateurs avec la personnalisation des domaines et des liens, que ce soit à partir de pools d’IPs partagés ou d’une IP dédiée.
- Éliminez l’usurpation d’identité et l’hameçonnage des noms de domaine grâce à la création d’enregistrements SPF et DKIM personnalisés.
- Bénéficiez d’un flux de courrier continu à travers nos centres de données sécurisés, distribués et redondants.
- Logs en direct et consultables.
 >- Pour utiliser Sendgrid il faut avoir un Nom de Domaine où seront stockés les noms et records pour authentification de domaine . La clé d'accés au service Sendgrid sera disponible dans le fichier sendgrid.txt. Pour plus d'information voir le fichier [sendgrid.md](sendgrid.md) et la [doc api sendgrid](https://docs.sendgrid.com/api-reference/mail-send/mail-send).




---
### <img src="https://img.icons8.com/external-flaticons-lineal-color-flat-icons/40/000000/external-contribution-achievements-flaticons-lineal-color-flat-icons.png"/>Contributing
- Ceci est un projet étudiant, les pull requests ne provenant pas des éléves de la promo 20 cloud Simplon sont refusées pour le moment. 
- Merci d'ouvrir une issue en premier pour discuter les changement que vous voudriez apporter avant de pull request.

---
### <img src="https://img.icons8.com/external-flaticons-flat-flat-icons/40/000000/external-fire-extinguisher-wayfinding-flaticons-flat-flat-icons.png"/>Known issues (work in progress)

C'est un projet en cours de developement.
- Les resources sont crées sur azure, pour d'autre fournisseur cloud il faut modifier le code.
- La sécurisation des données via l'utilisation d'un keyvault reste à faire.
- La connexion au serveur de base de données ne se fait pas : veillez à indiquer le bon chemin vers le certificat ssl téléchargé dans la commande de connexion.
