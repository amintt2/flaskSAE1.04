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

* Exécutez le projet en lançant `flask run --debug` dans votre répertoire de projet.
* Ouvrez un navigateur web et accédez à `http://localhost:5000` pour voir le site web en action.

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

## Ajout d'une nouvelle catégorie comme la vente ou le marché

Pour ajouter une nouvelle catégorie comme la vente ou le marché, vous devrez suivre les étapes suivantes :

1. Créez une nouvelle table dans votre base de données pour stocker les informations de la nouvelle catégorie.
2. Ajoutez des routes HTTP GET et POST dans le fichier `app.py` pour gérer les demandes liées à la nouvelle catégorie.
3. Créez des modèles pour la nouvelle catégorie dans le fichier `app.py` pour interagir avec la base de données.
4. Créez des vues HTML pour afficher les informations de la nouvelle catégorie.
5. Mettez à jour les routes et les modèles existants pour intégrer la nouvelle catégorie dans le système.

En suivant ces étapes, vous pourrez facilement ajouter de nouvelles fonctionnalités au projet pour gérer d'autres aspects de votre système de gestion de récoltes.
