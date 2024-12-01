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

-- Independent tables first
INSERT INTO Maraicher (Nom, Prenom, Adresse, Telephone, Email) VALUES
('Dupont', 'Jean', '123 rue des Legumes', '0123456789', 'jean.dupont@email.com'),
('Martin', 'Marie', '456 avenue des Fruits', '0234567890', 'marie.martin@email.com'),
('Bernard', 'Pierre', '789 boulevard Bio', '0345678901', 'pierre.bernard@email.com');

INSERT INTO TypeProduit (libelle) VALUES
('Legume'),
('Fruit'),
('Herbe aromatique'),
('Legume-fruit');

INSERT INTO Saison (Date_saison, libelle_saison) VALUES
('2024-03-20', 'Printemps'),
('2024-06-21', 'ete'),
('2024-09-22', 'Automne'),
('2024-12-21', 'Hiver');

INSERT INTO LieuMarche (nom) VALUES
('Place Centrale'),
('Marche Couvert'),
('Place de la Mairie'),
('Halle aux Legumes');

-- Tables with single dependencies
INSERT INTO Marche (ID_Marche, nom_mache, date_march, code_lieu) VALUES
(1, 'Marche Bio', '2024-04-01', 1),
(2, 'Marche des Producteurs', '2024-04-02', 2),
(3, 'Marche Local', '2024-04-03', 3);

INSERT INTO Produit (nom_produit, idTypeproduit) VALUES
('Tomate', 4),
('Carotte', 1),
('Pomme', 2),
('Basilic', 3),
('Courgette', 1);

-- Tables with multiple dependencies
INSERT INTO Vente (Date_Vente, ID_Marche, ID_Maraicher) VALUES
('2024-04-01', 1, 1),
('2024-04-02', 2, 2),
('2024-04-03', 3, 3);

INSERT INTO recolte (quantite, Date_Debut, ID_Produit, ID_Maraicher) VALUES
(100, '2024-03-15', 1, 1),
(150, '2024-03-16', 2, 2),
(200, '2024-03-17', 3, 3);

INSERT INTO est_vendu (ID_Est_Vendu, quantite, prix, ID_Vente, ID_Produit) VALUES
(1, 50, 200, 1, 1),
(2, 75, 150, 2, 2),
(3, 100, 300, 3, 3);

INSERT INTO est_dans (ID_Maraicher, ID_Marche) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO recolte_ce_type (ID_Maraicher, idTypeproduit) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO est_de_saison (ID_Produit, code_saison) VALUES
(1, 2), -- Tomates en ete
(2, 1), -- Carottes au printemps
(3, 3), -- Pommes en automne
(4, 2), -- Basilic en ete
(5, 2); -- Courgettes en ete
