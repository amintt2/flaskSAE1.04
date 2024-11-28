#!/usr/bin/python
# -*- coding:utf-8 -*-
from flask import Flask, request, render_template, redirect, flash
import time
from datetime import date

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
            user="constantsuchet",
            password="Password123!",
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
    
    # Requête principale pour les récoltes
    sql_recoltes = """
        SELECT recolte.*, Produit.nom_produit, Maraicher.Nom, Maraicher.Prénom 
        FROM recolte
        JOIN Produit ON recolte.ID_Produit = Produit.ID_Produit
        JOIN Maraicher ON recolte.ID_Maraicher = Maraicher.ID_Maraicher
    """
    
    # Requête pour les statistiques par produit
    sql_stats = """
        SELECT 
            Produit.nom_produit,
            COUNT(*) as nombre_recoltes,
            SUM(recolte.quantité) as quantite_totale,
            AVG(recolte.quantité) as moyenne_quantite
        FROM recolte
        JOIN Produit ON recolte.ID_Produit = Produit.ID_Produit
        GROUP BY Produit.ID_Produit, Produit.nom_produit
    """
    
    mycursor.execute(sql_recoltes)
    recoltes = mycursor.fetchall()
    
    mycursor.execute(sql_stats)
    stats = mycursor.fetchall()
    
    return render_template('recolte/show_recolte.html', 
                         recoltes=recoltes,
                         stats=stats)

@app.route('/recolte/add', methods=['GET'])
def add_recolte_get():
    mycursor = get_db().cursor()
    
    # Get all products and check which ones are in récolte
    sql_produits = """
        SELECT Produit.*, 
               CASE WHEN recolte.ID_Produit IS NOT NULL THEN 1 ELSE 0 END as in_recolte
        FROM Produit
        LEFT JOIN recolte ON Produit.ID_Produit = recolte.ID_Produit
    """
    mycursor.execute(sql_produits)
    produits = mycursor.fetchall()
    
    # Get all maraichers and check which ones are in récolte
    sql_maraichers = """
        SELECT Maraicher.*, 
               CASE WHEN recolte.ID_Maraicher IS NOT NULL THEN 1 ELSE 0 END as in_recolte
        FROM Maraicher
        LEFT JOIN recolte ON Maraicher.ID_Maraicher = recolte.ID_Maraicher
    """
    mycursor.execute(sql_maraichers)
    maraichers = mycursor.fetchall()
    
    today_date = date.today().strftime('%Y-%m-%d')
    return render_template('recolte/add_recolte.html', 
                         produits=produits, 
                         maraichers=maraichers,
                         today_date=today_date)

@app.route('/recolte/add', methods=['POST'])
def add_recolte_post():
    mycursor = get_db().cursor()
    quantite = request.form.get('quantité', type=int)
    date_debut = request.form.get('Date_Debut')
    id_produit = request.form.get('ID_Produit', type=int)
    id_maraicher = request.form.get('ID_Maraicher', type=int)

    # Vérification pour le maraîcher
    check_sql = """
        SELECT * FROM recolte WHERE ID_Maraicher = %s
    """
    mycursor.execute(check_sql, (id_maraicher,))    
    existing_recolte = mycursor.fetchone()

    if existing_recolte:  # Supprimez la comparaison avec id_recolte car c'est un ajout
        flash('Ce maraicher a déjà une récolte en cours', 'error')
        return redirect('/recolte/add')

    # Vérification pour le produit
    check_sql = """
        SELECT * FROM recolte WHERE ID_Produit = %s
    """
    mycursor.execute(check_sql, (id_produit,))
    existing_recolte = mycursor.fetchone()

    if existing_recolte:  # Supprimez la comparaison avec id_recolte car c'est un ajout
        flash('Ce produit a déjà une récolte en cours', 'error')
        return redirect('/recolte/add')

    # Le reste du code reste inchangé
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
    id_recolte = request.args.get('id', type=int)
    
    if not id_recolte:
        flash('ID récolte non spécifié', 'error')
        return redirect('/recolte')
    
    mycursor = get_db().cursor()
    
    # Get current récolte info
    sql = """
        SELECT recolte.*, Produit.nom_produit, Maraicher.Nom, Maraicher.Prénom 
        FROM recolte 
        JOIN Produit ON recolte.ID_produit = Produit.ID_produit 
        JOIN Maraicher ON recolte.ID_maraicher = Maraicher.ID_maraicher 
        WHERE recolte.ID_recolte = %s
    """
    mycursor.execute(sql, (id_recolte,))
    recolte = mycursor.fetchone()
    
    if not recolte:
        flash('Récolte non trouvée', 'error')
        return redirect('/recolte')
    
    # Get products with in_recolte status, excluding current récolte
    sql_produits = """
        SELECT Produit.*, 
               CASE WHEN (recolte.ID_Produit IS NOT NULL AND recolte.ID_recolte != %s) THEN 1 ELSE 0 END as in_recolte
        FROM Produit
        LEFT JOIN recolte ON Produit.ID_Produit = recolte.ID_Produit
    """
    mycursor.execute(sql_produits, (id_recolte,))
    produits = mycursor.fetchall()
    
    # Get maraichers with in_recolte status, excluding current récolte
    sql_maraichers = """
        SELECT Maraicher.*, 
               CASE WHEN (recolte.ID_Maraicher IS NOT NULL AND recolte.ID_recolte != %s) THEN 1 ELSE 0 END as in_recolte
        FROM Maraicher
        LEFT JOIN recolte ON Maraicher.ID_Maraicher = recolte.ID_Maraicher
    """
    mycursor.execute(sql_maraichers, (id_recolte,))
    maraichers = mycursor.fetchall()
    
    return render_template('recolte/edit_recolte.html', 
                         recolte=recolte, 
                         produits=produits, 
                         maraichers=maraichers)

@app.route('/recolte/edit', methods=['POST'])
def edit_recolte_post():
    mycursor = get_db().cursor()
    id_recolte = request.form.get('ID_recolte', type=int)
    quantite = request.form.get('quantité', type=int)
    date_debut = request.form.get('Date_Debut')
    id_produit = request.form.get('ID_Produit', type=int)
    id_maraicher = request.form.get('ID_Maraicher', type=int)

    check_sql = """
        SELECT * FROM recolte WHERE ID_Maraicher = %s
    """

    mycursor.execute(check_sql, (id_maraicher,))    
    existing_recolte = mycursor.fetchone()

    if existing_recolte and existing_recolte['ID_recolte'] != id_recolte:
        flash('Ce maraicher a déjà une récolte en cours', 'error')
        return redirect('/recolte/edit?id=' + str(id_recolte))

    check_sql = """
        SELECT * FROM recolte WHERE ID_Produit = %s
    """
    mycursor.execute(check_sql, (id_produit,))
    existing_recolte = mycursor.fetchone()

    if existing_recolte and existing_recolte['ID_recolte'] != id_recolte:
        flash('Ce produit a déjà une récolte en cours', 'error')
        return redirect('/recolte/edit?id=' + str(id_recolte))

    
    sql = """
        UPDATE recolte 
        SET quantité = %s, Date_Debut = %s, ID_Produit = %s, ID_Maraicher = %s
        WHERE ID_recolte = %s
    """
    mycursor.execute(sql, (quantite, date_debut, id_produit, id_maraicher, id_recolte))
    get_db().commit()
    
    flash('Récolte mise à jour avec succès', 'success')
    return redirect('/recolte')

@app.route('/recolte/delete', methods=['POST'])
def delete_recolte():
    id_recolte = request.form.get('ID_recolte', type=int)
    mycursor = get_db().cursor()
    mycursor.execute("DELETE FROM recolte WHERE ID_recolte = %s", (id_recolte,))
    get_db().commit()
    return redirect('/recolte')

@app.route('/conflicts/recolte/<int:recolte_id>')
def show_recolte_conflicts(recolte_id):
    mycursor = get_db().cursor()
    
    sql = """
        SELECT recolte.*, Produit.nom_produit, Maraicher.Nom, Maraicher.Prénom 
        FROM recolte
        LEFT JOIN Produit ON recolte.ID_Produit = Produit.ID_Produit
        LEFT JOIN Maraicher ON recolte.ID_Maraicher = Maraicher.ID_Maraicher
        WHERE recolte.ID_recolte = %s
    """
    mycursor.execute(sql, (recolte_id,))
    recolte = mycursor.fetchone()
    
    if not recolte:
        flash('Récolte non trouvée', 'error')
        return redirect('/recolte')
    
    conflicts = {}
    
    if recolte['ID_Produit']:
        conflicts['produit'] = {
            'ID_Produit': recolte['ID_Produit'],
            'nom_produit': recolte['nom_produit']
        }
    
    if recolte['ID_Maraicher']:
        conflicts['maraicher'] = {
            'ID_Maraicher': recolte['ID_Maraicher'],
            'Nom': recolte['Nom'],
            'Prénom': recolte['Prénom']
        }
    
    return render_template('recolte/conflict_recolte.html', 
                         conflicts=conflicts if conflicts else None,
                         recolte_id=recolte_id)

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


