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
('Bernard', 'Luc', '789 Boulevard de Nice', '0147258369', 'luc.bernard@example.com'),
('Dubois', 'Marie', '234 Rue des Fleurs', '0123456780', 'marie.dubois@example.com'),
('Petit', 'Pierre', '567 Avenue du Soleil', '0123456781', 'pierre.petit@example.com'),
('Leroy', 'Sophie', '890 Boulevard des Arts', '0123456782', 'sophie.leroy@example.com'),
('Moreau', 'Thomas', '123 Rue de la Paix', '0123456783', 'thomas.moreau@example.com'),
('Roux', 'Julie', '456 Avenue des Roses', '0123456784', 'julie.roux@example.com');

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
('Basilic', 4, 3),
('Poireau', 2, 1),
('Courgette', 1, 1),
('Poire', 3, 2),
('Fraise', 5, 2),
('Menthe', 3, 3),
('Ciboulette', 2, 3),
('Aubergine', 2, 1),
('Radis', 1, 1),
('Cerise', 6, 2),
('Thym', 3, 3);

INSERT INTO Vente (Date_Vente, ID_Marche, ID_Maraicher, prix_emplacement) VALUES
('2023-01-11', 1, 1, 50),
('2023-01-16', 2, 2, 60),
('2023-01-21', 3, 3, 40),
('2023-02-11', 1, 4, 55),
('2023-02-16', 2, 5, 65),
('2023-03-21', 3, 1, 45),
('2023-04-11', 1, 2, 52),
('2023-04-16', 2, 3, 62),
('2023-05-21', 3, 4, 42),
('2023-06-11', 1, 5, 58),
('2023-06-16', 2, 1, 68);


INSERT INTO recolte (quantite, Date_Debut, ID_Produit, ID_Maraicher) VALUES
(100, '2023-01-01', 1, 1),
(200, '2023-01-10', 2, 2),
(75, '2023-01-20', 3, 3),
(150, '2023-02-01', 1, 1),
(300, '2023-02-10', 2, 2),
(200, '2023-02-20', 3, 3),
(250, '2023-03-01', 4, 4),
(175, '2023-03-10', 5, 5),
(225, '2023-03-20', 6, 1),
(350, '2023-04-01', 7, 2),
(125, '2023-04-10', 8, 3),
(275, '2023-04-20', 9, 4),
(400, '2023-05-01', 10, 5),
(180, '2023-05-10', 1, 2),
(320, '2023-05-20', 2, 3),
(240, '2023-06-01', 3, 4),
(290, '2023-06-10', 4, 5),
(160, '2023-06-20', 5, 1);

INSERT INTO est_vendu (quantite, prix, ID_Vente, ID_Produit) VALUES
(10, 20, 1, 1),
(5, 15, 2, 2),
(8, 24, 3, 3),
(15, 25, 1, 4),
(12, 18, 2, 5),
(20, 30, 3, 6),
(18, 27, 4, 7),
(25, 38, 5, 8),
(22, 33, 6, 9),
(30, 45, 7, 10),
(28, 42, 8, 1),
(35, 53, 1, 2),
(32, 48, 2, 3),
(40, 60, 3, 4),
(38, 57, 4, 5);


INSERT INTO est_dans (ID_Maraicher, ID_Marche) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2);


INSERT INTO recolte_ce_type (ID_Maraicher, idTypeproduit) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2);

INSERT INTO est_de_saison (ID_Produit, code_saison) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 3),
(7, 1),
(8, 2),
(9, 3),
(10, 1);

