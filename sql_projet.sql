CREATE DATABASE IF NOT EXISTS maraicher_db;
USE maraicher_db;

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS est_de_saison;
DROP TABLE IF EXISTS recolte_ce_type;
DROP TABLE IF EXISTS est_dans;
DROP TABLE IF EXISTS est_vendu;
DROP TABLE IF EXISTS recolte;
DROP TABLE IF EXISTS Vente;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Marché;
DROP TABLE IF EXISTS LieuMarché;
DROP TABLE IF EXISTS Saison;
DROP TABLE IF EXISTS TypeProduit;
DROP TABLE IF EXISTS Maraicher;

-- Create tables in correct dependency order
CREATE TABLE Maraicher(
   ID_Maraicher INT AUTO_INCREMENT,
   Nom VARCHAR(50),
   Prénom VARCHAR(50),
   Adresse VARCHAR(50),
   Téléphone VARCHAR(15),
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

CREATE TABLE LieuMarché(
   code_lieu INT AUTO_INCREMENT,
   nom VARCHAR(50),
   PRIMARY KEY(code_lieu)
);

CREATE TABLE Marché( -- enlever les accents
   ID_Marché INT,
   nom_maché VARCHAR(50),
   date_march DATE,
   -- nombre de standes a ajouter
   code_lieu INT NOT NULL,
   PRIMARY KEY(ID_Marché),
   FOREIGN KEY(code_lieu) REFERENCES LieuMarché(code_lieu)
);

CREATE TABLE Produit(
   ID_Produit INT AUTO_INCREMENT,
   nom_produit VARCHAR(50),
   -- rajouter prix de vente
   idTypeproduit INT NOT NULL,
   PRIMARY KEY(ID_Produit),
   FOREIGN KEY(idTypeproduit) REFERENCES TypeProduit(idTypeproduit)
);

CREATE TABLE Vente(
   ID_Vente INT AUTO_INCREMENT,
   Date_Vente DATE,
   ID_Marché INT NOT NULL,
   ID_Maraicher INT NOT NULL,
   -- Prix emplacement a ajouter
   PRIMARY KEY(ID_Vente),
   FOREIGN KEY(ID_Marché) REFERENCES Marché(ID_Marché),
   FOREIGN KEY(ID_Maraicher) REFERENCES Maraicher(ID_Maraicher)
);

CREATE TABLE recolte(
   ID_recolte INT AUTO_INCREMENT,
   quantité INT,
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
   -- id vendu
   quantité INT,
   prix INT,
   ID_Vente INT NOT NULL,
   ID_Produit INT NOT NULL,
   PRIMARY KEY(ID_Vente),
   FOREIGN KEY(ID_Vente) REFERENCES Vente(ID_Vente),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit)
);

CREATE TABLE est_dans(
   ID_Maraicher INT,
   ID_Marché INT,
   PRIMARY KEY(ID_Maraicher, ID_Marché),
   FOREIGN KEY(ID_Maraicher) REFERENCES Maraicher(ID_Maraicher),
   FOREIGN KEY(ID_Marché) REFERENCES Marché(ID_Marché)
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

-- Independent tables first
INSERT INTO Maraicher (Nom, Prénom, Adresse, Téléphone, Email) VALUES
('Dupont', 'Jean', '123 rue des Légumes', '0123456789', 'jean.dupont@email.com'),
('Martin', 'Marie', '456 avenue des Fruits', '0234567890', 'marie.martin@email.com'),
('Bernard', 'Pierre', '789 boulevard Bio', '0345678901', 'pierre.bernard@email.com');

INSERT INTO TypeProduit (libelle) VALUES
('Légume'),
('Fruit'),
('Herbe aromatique'),
('Légume-fruit');

INSERT INTO Saison (Date_saison, libelle_saison) VALUES
('2024-03-20', 'Printemps'),
('2024-06-21', 'Été'),
('2024-09-22', 'Automne'),
('2024-12-21', 'Hiver');

INSERT INTO LieuMarché (nom) VALUES
('Place Centrale'),
('Marché Couvert'),
('Place de la Mairie'),
('Halle aux Légumes');

-- Tables with single dependencies
INSERT INTO Marché (ID_Marché, nom_maché, date_march, code_lieu) VALUES
(1, 'Marché Bio', '2024-04-01', 1),
(2, 'Marché des Producteurs', '2024-04-02', 2),
(3, 'Marché Local', '2024-04-03', 3);

INSERT INTO Produit (nom_produit, idTypeproduit) VALUES
('Tomate', 4),
('Carotte', 1),
('Pomme', 2),
('Basilic', 3),
('Courgette', 1);

-- Tables with multiple dependencies
INSERT INTO Vente (Date_Vente, ID_Marché, ID_Maraicher) VALUES
('2024-04-01', 1, 1),
('2024-04-02', 2, 2),
('2024-04-03', 3, 3);

INSERT INTO recolte (quantité, Date_Debut, ID_Produit, ID_Maraicher) VALUES
(100, '2024-03-15', 1, 1),
(150, '2024-03-16', 2, 2),
(200, '2024-03-17', 3, 3);

INSERT INTO est_vendu (quantité, prix, ID_Vente, ID_Produit) VALUES
(50, 200, 1, 1),
(75, 150, 2, 2),
(100, 300, 3, 3);

INSERT INTO est_dans (ID_Maraicher, ID_Marché) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO recolte_ce_type (ID_Maraicher, idTypeproduit) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO est_de_saison (ID_Produit, code_saison) VALUES
(1, 2), -- Tomates en été
(2, 1), -- Carottes au printemps
(3, 3), -- Pommes en automne
(4, 2), -- Basilic en été
(5, 2); -- Courgettes en été
