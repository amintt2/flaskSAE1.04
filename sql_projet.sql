DROP TABLE IF EXISTS Maraîcher;
DROP TABLE IF EXISTS TypeProduit;
DROP TABLE IF EXISTS Saison;
DROP TABLE IF EXISTS LieuMarché;
DROP TABLE IF EXISTS Marché;
DROP TABLE IF EXISTS Produit;
DROP TABLE IF EXISTS Vente;
DROP TABLE IF EXISTS recolte;
DROP TABLE IF EXISTS est_vendu;
DROP TABLE IF EXISTS est_dans;
DROP TABLE IF EXISTS recolte_ce_type;
DROP TABLE IF EXISTS est_de_saison;

CREATE TABLE Maraîcher(
   ID_Maraîcher COUNTER,
   Nom VARCHAR(50),
   Prénom VARCHAR(50),
   Adresse VARCHAR(50),
   Téléphone VARCHAR(15),
   Email VARCHAR(50),
   PRIMARY KEY(ID_Maraîcher)
);

CREATE TABLE TypeProduit(
   idTypeproduit COUNTER,
   libelle VARCHAR(50),
   PRIMARY KEY(idTypeproduit)
);

CREATE TABLE Saison(
   code_saison COUNTER,
   Date_saison DATE NOT NULL,
   libelle_saison VARCHAR(50),
   PRIMARY KEY(code_saison)
);

CREATE TABLE LieuMarché(
   code_lieu COUNTER,
   nom VARCHAR(50),
   PRIMARY KEY(code_lieu)
);

CREATE TABLE Marché(
   ID_Marché INT,
   nom_maché VARCHAR(50),
   date_marché DATE,
   code_lieu INT NOT NULL,
   PRIMARY KEY(ID_Marché),
   FOREIGN KEY(code_lieu) REFERENCES LieuMarché(code_lieu)
);

CREATE TABLE Produit(
   ID_Produit COUNTER,
   nom_produit VARCHAR(50),
   idTypeproduit INT NOT NULL,
   PRIMARY KEY(ID_Produit),
   FOREIGN KEY(idTypeproduit) REFERENCES TypeProduit(idTypeproduit)
);

CREATE TABLE Vente(
   ID_Vente COUNTER,
   Date_Vente DATE,
   ID_Marché INT NOT NULL,
   ID_Maraîcher INT NOT NULL,
   PRIMARY KEY(ID_Vente),
   FOREIGN KEY(ID_Marché) REFERENCES Marché(ID_Marché),
   FOREIGN KEY(ID_Maraîcher) REFERENCES Maraîcher(ID_Maraîcher)
);

CREATE TABLE recolte(
   quantité INT,
   Date_Debut DATE NOT NULL,
   ID_Produit INT NOT NULL,
   ID_Maraîcher INT NOT NULL,
   PRIMARY KEY(quantité),
   UNIQUE(ID_Produit),
   UNIQUE(ID_Maraîcher),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit),
   FOREIGN KEY(ID_Maraîcher) REFERENCES Maraîcher(ID_Maraîcher)
);

CREATE TABLE est_vendu(
   quantité INT,
   prix INT,
   ID_Vente INT NOT NULL,
   ID_Produit INT NOT NULL,
   PRIMARY KEY(quantité),
   FOREIGN KEY(ID_Vente) REFERENCES Vente(ID_Vente),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit)
);

CREATE TABLE est_dans(
   ID_Maraîcher INT,
   ID_Marché INT,
   PRIMARY KEY(ID_Maraîcher, ID_Marché),
   FOREIGN KEY(ID_Maraîcher) REFERENCES Maraîcher(ID_Maraîcher),
   FOREIGN KEY(ID_Marché) REFERENCES Marché(ID_Marché)
);

CREATE TABLE recolte_ce_type(
   ID_Maraîcher INT,
   idTypeproduit INT,
   PRIMARY KEY(ID_Maraîcher, idTypeproduit),
   FOREIGN KEY(ID_Maraîcher) REFERENCES Maraîcher(ID_Maraîcher),
   FOREIGN KEY(idTypeproduit) REFERENCES TypeProduit(idTypeproduit)
);

CREATE TABLE est_de_saison(
   ID_Produit INT,
   code_saison INT,
   PRIMARY KEY(ID_Produit, code_saison),
   FOREIGN KEY(ID_Produit) REFERENCES Produit(ID_Produit),
   FOREIGN KEY(code_saison) REFERENCES Saison(code_saison)
);


