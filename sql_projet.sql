CREATE DATABASE IF NOT EXISTS maraicher_db;
USE maraicher_db;

DROP DATABASE IF EXISTS maraicher_db;

CREATE DATABASE IF NOT EXISTS maraicher_db;

USE maraicher_db;

-- Create tables in correct dependency order
CREATE TABLE Maraicher(
   ID_Maraicher INT AUTO_INCREMENT,
   Nom VARCHAR(50),
   Prenom VARCHAR(50),
   Adresse VARCHAR(50),
   Telephone VARCHAR(15),
   Email VARCHAR(50),
   PRIMARY KEY(ID_Maraicher)
);

CREATE TABLE TypeProduit(
   idTypeproduit INT AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(idTypeproduit)
);

CREATE TABLE Saison(
   code_saison INT AUTO_INCREMENT,
   Date_saison DATE NOT NULL,
   libelle_saison VARCHAR(50),
   PRIMARY KEY(code_saison)
);

CREATE TABLE LieuMarche(
   code_lieu INT AUTO_INCREMENT,
   nom VARCHAR(50),
   PRIMARY KEY(code_lieu)
);

CREATE TABLE Marche( -- enlever les accents
   ID_Marche INT,
   nom_mache VARCHAR(50),
   date_march DATE,
   nombre_standes INT,
   code_lieu INT NOT NULL,
   PRIMARY KEY(ID_Marche),
   FOREIGN KEY(code_lieu) REFERENCES LieuMarche(code_lieu)
);

CREATE TABLE Produit(
   ID_Produit INT AUTO_INCREMENT,
   nom_produit VARCHAR(50),
   prix_vente INT,
   idTypeproduit INT NOT NULL,
   PRIMARY KEY(ID_Produit),
   FOREIGN KEY(idTypeproduit) REFERENCES TypeProduit(idTypeproduit)
);

CREATE TABLE Vente(
   ID_Vente INT AUTO_INCREMENT,
   Date_Vente DATE,
   ID_Marche INT NOT NULL,
   ID_Maraicher INT NOT NULL,
   prix_emplacement INT,
   PRIMARY KEY(ID_Vente),
   FOREIGN KEY(ID_Marche) REFERENCES Marche(ID_Marche),
   FOREIGN KEY(ID_Maraicher) REFERENCES Maraicher(ID_Maraicher)
);

CREATE TABLE recolte(
   ID_recolte INT AUTO_INCREMENT,
   quantite INT,
   Date_Debut DATE NOT NULL,
   ID_Produit INT NOT NULL,
   ID_Maraicher INT NOT NULL,
   PRIMARY KEY(ID_recolte),
   UNIQUE(ID_Produit),
   UNIQUE(ID_Maraicher),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit),
   FOREIGN KEY(ID_Maraicher) REFERENCES Maraicher(ID_Maraicher)
);

CREATE TABLE est_vendu( -- changer nom
   ID_Est_Vendu INT AUTO_INCREMENT,
   quantite INT,
   prix INT,
   ID_Vente INT NOT NULL,
   ID_Produit INT NOT NULL,
   PRIMARY KEY(ID_Est_Vendu),
   FOREIGN KEY(ID_Vente) REFERENCES Vente(ID_Vente),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit)
);

CREATE TABLE est_dans(
   ID_Maraicher INT,
   ID_Marche INT,
   PRIMARY KEY(ID_Maraicher, ID_Marche),
   FOREIGN KEY(ID_Maraicher) REFERENCES Maraicher(ID_Maraicher),
   FOREIGN KEY(ID_Marche) REFERENCES Marche(ID_Marche)
);

CREATE TABLE recolte_ce_type(
   ID_Maraicher INT,
   idTypeproduit INT,
   PRIMARY KEY(ID_Maraicher, idTypeproduit),
   FOREIGN KEY(ID_Maraicher) REFERENCES Maraicher(ID_Maraicher),
   FOREIGN KEY(idTypeproduit) REFERENCES TypeProduit(idTypeproduit)
);

CREATE TABLE est_de_saison(
   ID_Produit INT,
   code_saison INT,
   PRIMARY KEY(ID_Produit, code_saison),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit),
   FOREIGN KEY(code_saison) REFERENCES Saison(code_saison)
);

