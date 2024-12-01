# Tutoriel pour le setup et l'explication du projet

Ce tutoriel vous guidera pas à pas pour le setup et l'explication du projet de gestion de récoltes. Vous apprendrez comment configurer le projet, comprendre les requêtes HTTP GET et POST implémentées dans le fichier `app.py` pour la gestion des récoltes, et comment ajouter de nouvelles fonctionnalités comme la gestion des ventes ou des marchés.

## Configuration du projet

### Étapes préalables

* Assurez-vous d'avoir Python installé sur votre ordinateur.
* Installez un gestionnaire de paquets virtuels comme `pip` ou `conda`.
* Créez un environnement virtuel pour votre projet avec `python -m venv mon_environnement` (remplacez `mon_environnement` par le nom de votre choix).
* Activez votre environnement virtuel en exécutant `source mon_environnement/bin/activate` (ou `activate` sur Windows).

### Installation des dépendances

* Installez les dépendances nécessaires en exécutant `pip install -r requirements.txt` dans votre répertoire de projet.

### Configuration de la base de données

* **Si vous n'avez pas encore créé la base de données et l'utilisateur MySQL, suivez ces étapes :**

**Attention :**
- il faut se connecter avec l'utilisateur root de MySQL
- mots de passe de l'utilisateur root de MySQL a été change lors de la création de la base de données

  0.**Connectez vous avec l'utilisateur root de MySQL :**
     ```bash
     mysql -u root -p
     ``` 

  1. **Créez une base de données MySQL :**
     ```sql
     CREATE DATABASE maraicher_db;
     ```

  2. **Créez un utilisateur MySQL :**
     ```sql
     CREATE USER 'constantsuchet'@'localhost' IDENTIFIED BY 'Password123!';
     ```

  3. **Accordez les privilèges à l'utilisateur sur la base de données :**
     ```sql
     GRANT ALL PRIVILEGES ON maraicher_db.* TO 'constantsuchet'@'localhost';
     FLUSH PRIVILEGES;
     ```

* Modifiez les informations de connexion à la base de données dans le fichier `app.py` pour correspondre à vos paramètres de base de données.

### Lancement du projet

* Rendez le script de lancement exécutable :
  ```bash
  chmod u+x Launcher.sh
  ```

* Lancez le projet en utilisant le script :
  ```bash
  ./Launcher.sh
  ```

Ce script va :
1. Créer un environnement virtuel s'il n'existe pas déjà
2. Installer les dépendances nécessaires
3. Lancer le serveur Flask en mode debug

## Comprendre les requêtes HTTP GET et POST pour la gestion des récoltes

### GET /recolte

* Cette requête affiche la liste de toutes les récoltes actuelles dans la base de données.
* Elle utilise une requête SQL pour récupérer toutes les récoltes, puis les affiche dans une page HTML.

### GET /recolte/add

* Cette requête affiche le formulaire d'ajout d'une nouvelle récolte.
* Elle récupère également la liste des produits et des maraîchers actifs pour les afficher dans le formulaire.

### POST /recolte/add

* Cette requête traite le formulaire d'ajout d'une nouvelle récolte.
* Elle vérifie si le maraîcher ou le produit sont déjà associés à une récolte en cours, puis ajoute la nouvelle récolte à la base de données si tout est valide.

### GET /recolte/edit

* Cette requête affiche le formulaire d'édition d'une récolte existante.
* Elle récupère les détails de la récolte spécifiée par son ID, ainsi que la liste des produits et des maraîchers actifs pour les afficher dans le formulaire.

### POST /recolte/edit

* Cette requête traite le formulaire d'édition d'une récolte existante.
* Elle met à jour les détails de la récolte dans la base de données si tout est valide.

## Création d'une nouvelle catégorie basée sur la récolte avec une nouvelle clé étrangère et une table déjà définie dans le projet SQLx

Pour créer une nouvelle catégorie basée sur la récolte, mais avec une nouvelle clé étrangère et une table déjà définie dans le projet SQL, vous devrez suivre les étapes suivantes :

1. Utilisez la table `Vente` déjà définie dans le projet SQL pour stocker les informations de la nouvelle catégorie.
2. Ajoutez des routes HTTP GET et POST dans le fichier `app.py` pour gérer les demandes liées à la nouvelle catégorie de vente. Par exemple, `/vente` pour afficher la liste des ventes et `/vente/add` pour ajouter une nouvelle vente.
3. Créez des modèles pour la nouvelle catégorie de vente dans le fichier `app.py` pour interagir avec la base de données. Vous pouvez utiliser les mêmes principes que pour la gestion des récoltes, mais en adaptant les modèles pour correspondre à la structure de la table `Vente`.
4. Créez des vues HTML pour afficher les informations de la nouvelle catégorie de vente. Vous pouvez créer un fichier `vente.html` pour afficher la liste des ventes et un fichier `add_vente.html` pour le formulaire d'ajout d'une nouvelle vente.
5. Mettez à jour les routes et les modèles existants pour intégrer la nouvelle catégorie de vente dans le système. Par exemple, vous pouvez ajouter des liens vers les pages de vente dans le menu de navigation ou ajouter des fonctionnalités pour afficher les ventes associées à une récolte spécifique.

En suivant ces étapes, vous pourrez facilement ajouter de nouvelles fonctionnalités au projet pour gérer les ventes, tout en utilisant les structures de données déjà définies dans le projet SQL.
