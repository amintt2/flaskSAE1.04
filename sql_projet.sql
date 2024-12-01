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

INSERT INTO Maraicher (Nom, Prenom, Adresse, Telephone, Email) VALUES
('Dupont', 'Jean', '123 Rue de Paris', '0123456789', 'jean.dupont@example.com'),
('Martin', 'Claire', '456 Avenue de Lyon', '0987654321', 'claire.martin@example.com'),
('Bernard', 'Luc', '789 Boulevard de Nice', '0147258369', 'luc.bernard@example.com');

INSERT INTO TypeProduit (libelle) VALUES
('Légume'),
('Fruit'),
('Herbe');


INSERT INTO Saison (Date_saison, libelle_saison) VALUES
('2023-01-01', 'Hiver'),
('2023-04-01', 'Printemps'),
('2023-07-01', 'Été'),
('2023-10-01', 'Automne');


INSERT INTO LieuMarche (nom) VALUES
('Marché Central'),
('Marché de Quartier'),
('Marché de Village');


INSERT INTO Marche (ID_Marche, nom_mache, date_march, nombre_standes, code_lieu) VALUES
(1, 'Marché de Paris', '2023-01-10', 10, 1),
(2, 'Marché de Lyon', '2023-01-15', 15, 2),
(3, 'Marché de Nice', '2023-01-20', 5, 3);

INSERT INTO Produit (nom_produit, prix_vente, idTypeproduit) VALUES
('Tomate', 2, 1),
('Carotte', 1, 1),
('Pomme', 3, 2),
('Basilic', 4, 3);

INSERT INTO Vente (Date_Vente, ID_Marche, ID_Maraicher, prix_emplacement) VALUES
('2023-01-11', 1, 1, 50),
('2023-01-16', 2, 2, 60),
('2023-01-21', 3, 3, 40);


INSERT INTO recolte (quantite, Date_Debut, ID_Produit, ID_Maraicher) VALUES
(100, '2023-01-01', 1, 1),
(200, '2023-01-10', 2, 2),
(75, '2023-01-20', 3, 3);

INSERT INTO est_vendu (quantite, prix, ID_Vente, ID_Produit) VALUES
(10, 20, 1, 1),
(5, 15, 2, 2),
(8, 24, 3, 3);


INSERT INTO est_dans (ID_Maraicher, ID_Marche) VALUES
(1, 1),
(2, 2),
(3, 3);


INSERT INTO recolte_ce_type (ID_Maraicher, idTypeproduit) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO est_de_saison (ID_Produit, code_saison) VALUES
(1, 1),
(2, 2),
(3, 3);

