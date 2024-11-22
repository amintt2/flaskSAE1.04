#!/usr/bin/python
# -*- coding:utf-8 -*-
from flask import Flask, request, render_template, redirect, flash
import time

app = Flask(__name__)
app.config["TEMPLATES_AUTO_RELOAD"] = True
app.secret_key = 'une cle(token) : grain de sel(any random string)'

                                    ## à ajouter
from flask import session, g
import pymysql.cursors

def get_db():
    if 'db' not in g:
        g.db = pymysql.connect(
            host="localhost",
            user="root",
            password="0422",
            database="maraicher_db",        # nom de votre base de données
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor
        )
    return g.db


@app.teardown_appcontext
def teardown_db(exception):
    db = g.pop('db', None)
    if db is not None:
        db.close()

@app.route('/')
def index():
    return redirect('/home')

@app.route('/home')
def home():
    creators = [
        {
            "name": "SUCHET Constant",
            "title": "Page Accueil et Maraîcher",
            "description": "Développement des pages accueil/recolte pour le projet de base de données SAE 1.04.",
            "profile_url": "/recolte", 
            "created_pages": {
                "Recolte": "/recolte",
            }
        },
        {
            "name": "TOUZI Tahar Amine",
            "title": "Page Produits",
            "description": "Développement de la page produits pour le projet de base de données SAE 1.04.",
            "profile_url": "/produit",
            "created_pages": {
                "Produit": "/produit",
            }
        },
        {
            "name": "SONET Noe",
            "title": "Page Marché", 
            "description": "Développement de la page marché pour le projet de base de données SAE 1.04.",
            "profile_url": "/marche",
            "created_pages": {
                "Marché": "/marche",
            }
        },
        {
            "name": "SPRINGER Theo",
            "title": "Page Vente",
            "description": "Développement de la page vente pour le projet de base de données SAE 1.04.",
            "profile_url": "/vente",
            "created_pages": {
                "Vente": "/vente", 
            }
        }
    ]
    return render_template('home.html', creators=creators)

@app.route('/recolte')
def show_recoltes():
    mycursor = get_db().cursor()
    sql = """
        SELECT r.*, p.nom_produit, m.Nom, m.Prénom 
        FROM recolte r
        JOIN Produit p ON r.ID_Produit = p.ID_Produit
        JOIN Maraicher m ON r.ID_Maraicher = m.ID_Maraicher
    """
    mycursor.execute(sql)
    recoltes = mycursor.fetchall()
    return render_template('recolte/show_recolte.html', recoltes=recoltes)

@app.route('/recolte/add', methods=['GET'])
def add_recolte_get():
    mycursor = get_db().cursor()
    mycursor.execute("SELECT * FROM Produit")
    produits = mycursor.fetchall()
    mycursor.execute("SELECT * FROM Maraicher")
    maraichers = mycursor.fetchall()
    return render_template('recolte/add_recolte.html', produits=produits, maraichers=maraichers)

@app.route('/recolte/add', methods=['POST'])
def add_recolte_post():
    quantite = request.form.get('quantité', type=int)
    date_debut = request.form.get('Date_Debut')
    id_produit = request.form.get('ID_Produit', type=int)
    id_maraicher = request.form.get('ID_Maraicher', type=int)
    
    mycursor = get_db().cursor()
    sql = """
        INSERT INTO recolte (quantité, Date_Debut, ID_Produit, ID_Maraicher) 
        VALUES (%s, %s, %s, %s)
    """
    mycursor.execute(sql, (quantite, date_debut, id_produit, id_maraicher))
    get_db().commit()
    
    flash('Récolte ajoutée avec succès', 'success')
    return redirect('/recolte')

@app.route('/recolte/edit', methods=['GET'])
def edit_recolte():
    # Get the ID from query parameters
    id_recolte = request.args.get('id', type=int)
    
    if not id_recolte:
        flash('ID récolte non spécifié', 'error')
        return redirect('/recolte')
    
    mycursor = get_db().cursor()
    # Join with produit and maraicher tables to get all necessary information
    sql = """
        SELECT r.*, p.nom_produit, m.Nom, m.Prénom 
        FROM recolte r 
        JOIN produit p ON r.ID_produit = p.ID_produit 
        JOIN maraicher m ON r.ID_maraicher = m.ID_maraicher 
        WHERE r.ID_recolte = %s
    """
    mycursor.execute(sql, (id_recolte,))
    recolte = mycursor.fetchone()
    
    if not recolte:
        flash('Récolte non trouvée', 'error')
        return redirect('/recolte')
    
    # Get list of products and maraichers for the form
    mycursor.execute("SELECT * FROM produit")
    produits = mycursor.fetchall()
    
    mycursor.execute("SELECT * FROM maraicher")
    maraichers = mycursor.fetchall()
    
    return render_template('recolte/edit_recolte.html', 
                         recolte=recolte, 
                         produits=produits, 
                         maraichers=maraichers)

@app.route('/recolte/edit', methods=['POST'])
def edit_recolte_post():
    id_recolte = request.form.get('ID_recolte', type=int)
    quantite = request.form.get('quantité', type=int)
    date_debut = request.form.get('Date_Debut')
    id_produit = request.form.get('ID_Produit', type=int)
    id_maraicher = request.form.get('ID_Maraicher', type=int)
    
    mycursor = get_db().cursor()
    sql = """
        UPDATE recolte 
        SET quantité = %s, Date_Debut = %s, ID_Produit = %s, ID_Maraicher = %s
        WHERE ID_recolte = %s
    """
    mycursor.execute(sql, (quantite, date_debut, id_produit, id_maraicher, id_recolte))
    get_db().commit()
    
    flash('Récolte mise à jour avec succès', 'success')
    return redirect('/recolte')

@app.route('/vente')
def vente():
    return render_template('vente/show_vente.html')

@app.route('/produit')
def produit():
    return render_template('produit/show_produit.html')

@app.route('/marche')
def marche():
    return render_template('marche/show_marche.html')

if __name__ == '__main__':
    app.run(debug=True)


