#!/usr/bin/python
# -*- coding:utf-8 -*-
from flask import Flask, request, render_template, redirect, flash
import time
from datetime import date, timedelta, datetime

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
            database="maraicher_db",        # nom de votre base de donnees
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
            "description": "Developpement des pages accueil/recolte pour le projet de base de donnees SAE 1.04.",
            "profile_url": "/recolte", 
            "created_pages": {
                "Recolte": "/recolte",
            }
        },
        {
            "name": "TOUZI Tahar Amine",
            "title": "Page Produits",
            "description": "Developpement de la page produits pour le projet de base de donnees SAE 1.04.",
            "profile_url": "/produit",
            "created_pages": {
                "Produit": "/produit",
            }
        },
        {
            "name": "SONET Noe",
            "title": "Page Marche", 
            "description": "Developpement de la page marche pour le projet de base de donnees SAE 1.04.",
            "profile_url": "/marche",
            "created_pages": {
                "Marche": "/marche",
            }
        },
        {
            "name": "SPRINGER Theo",
            "title": "Page Vente",
            "description": "Developpement de la page vente pour le projet de base de donnees SAE 1.04.",
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
    
    # Requête principale pour les recoltes
    sql_recoltes = """
        SELECT recolte.*, Produit.nom_produit, Maraicher.Nom, Maraicher.Prenom 
        FROM recolte
        JOIN Produit ON recolte.ID_Produit = Produit.ID_Produit
        JOIN Maraicher ON recolte.ID_Maraicher = Maraicher.ID_Maraicher
    """
    
    # Requête pour les statistiques par produit
    sql_stats = """
        SELECT 
            Produit.nom_produit,
            COUNT(*) as nombre_recoltes,
            SUM(recolte.quantite) as quantite_totale,
            AVG(recolte.quantite) as moyenne_quantite
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
    today_date = datetime.today()
    
    # Get all products and check which ones are in recolte within the date range
    sql_produits = """
        SELECT DISTINCT Produit.*, 
               CASE WHEN EXISTS (
                   SELECT 1 FROM recolte 
                   WHERE recolte.ID_Produit = Produit.ID_Produit
                   AND recolte.Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
                   AND recolte.Date_Debut > DATE_SUB(%s, INTERVAL 7 DAY)
               ) THEN 1 ELSE 0 END as in_recolte,
               (SELECT Date_Debut FROM recolte 
                WHERE recolte.ID_Produit = Produit.ID_Produit
                AND recolte.Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
                AND recolte.Date_Debut > DATE_SUB(%s, INTERVAL 7 DAY)
                LIMIT 1) as Date_Debut
        FROM Produit
    """
    mycursor.execute(sql_produits, (today_date, today_date, today_date, today_date))
    produits = mycursor.fetchall()
    
    # Get all maraichers and check which ones are in recolte within the date range
    sql_maraichers = """
        SELECT DISTINCT Maraicher.*, 
               CASE WHEN EXISTS (
                   SELECT 1 FROM recolte 
                   WHERE recolte.ID_Maraicher = Maraicher.ID_Maraicher
                   AND recolte.Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
                   AND recolte.Date_Debut > DATE_SUB(%s, INTERVAL 7 DAY)
               ) THEN 1 ELSE 0 END as in_recolte,
               (SELECT Date_Debut FROM recolte 
                WHERE recolte.ID_Maraicher = Maraicher.ID_Maraicher
                AND recolte.Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
                AND recolte.Date_Debut > DATE_SUB(%s, INTERVAL 7 DAY)
                LIMIT 1) as Date_Debut
        FROM Maraicher
    """
    mycursor.execute(sql_maraichers, (today_date, today_date, today_date, today_date))
    maraichers = mycursor.fetchall()
    
    today_date_str = today_date.strftime('%Y-%m-%d')
    next_week_date = (today_date + timedelta(days=7)).strftime('%Y-%m-%d')
    last_week_date = (today_date - timedelta(days=7)).strftime('%Y-%m-%d')

    return render_template('recolte/add_recolte.html', 
                         produits=produits, 
                         maraichers=maraichers,
                         today_date=today_date_str,
                         next_week_date=next_week_date,
                         last_week_date=last_week_date)

@app.route('/recolte/add', methods=['POST'])
def add_recolte_post():
    mycursor = get_db().cursor()
    quantite = request.form.get('quantite')
    date_debut = request.form.get('Date_Debut')
    id_produit = request.form.get('ID_Produit')
    id_maraicher = request.form.get('ID_Maraicher')

    # Verification pour le maraîcher
    check_sql = """
        SELECT * FROM recolte 
        WHERE ID_Maraicher = %s 
        AND Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
        AND Date_Debut > DATE_SUB(%s, INTERVAL 7 DAY)
    """
    mycursor.execute(check_sql, (id_maraicher, date_debut, date_debut))
    existing_recolte = mycursor.fetchone()

    if existing_recolte:
        flash('Ce maraicher a déjà une récolte prévue dans la même semaine', 'error')
        return redirect('/recolte/add')

    # Verification pour le produit
    check_sql = """
        SELECT * FROM recolte 
        WHERE ID_Produit = %s 
        AND Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
        AND Date_Debut > DATE_SUB(%s, INTERVAL 7 DAY)
    """
    mycursor.execute(check_sql, (id_produit, date_debut, date_debut))
    existing_recolte = mycursor.fetchone()

    if existing_recolte:
        flash('Ce produit a déjà une récolte prévue dans la même semaine', 'error')
        return redirect('/recolte/add')

    # Si aucun conflit, on ajoute la récolte
    sql = """
        INSERT INTO recolte (quantite, Date_Debut, ID_Produit, ID_Maraicher)
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
        flash('ID recolte non specifie', 'error')
        return redirect('/recolte')
    
    mycursor = get_db().cursor()
    
    # Get the basic recolte information
    sql = """
        SELECT recolte.*, Produit.nom_produit, Maraicher.Nom, Maraicher.Prenom 
        FROM recolte 
        JOIN Produit ON recolte.ID_produit = Produit.ID_produit 
        JOIN Maraicher ON recolte.ID_maraicher = Maraicher.ID_maraicher 
        WHERE recolte.ID_recolte = %s
    """
    mycursor.execute(sql, (id_recolte,))
    recolte = mycursor.fetchone()
    
    if not recolte:
        flash('Recolte non trouvee', 'error')
        return redirect('/recolte')

    # Get all products and maraichers
    mycursor.execute("SELECT * FROM Produit")
    produits = mycursor.fetchall()
    
    mycursor.execute("SELECT * FROM Maraicher")
    maraichers = mycursor.fetchall()
    
    # Calculate dates
    today_date = datetime.today()
    today_date_str = today_date.strftime('%Y-%m-%d')
    next_week_date = (today_date + timedelta(days=7)).strftime('%Y-%m-%d')
    last_week_date = (today_date - timedelta(days=7)).strftime('%Y-%m-%d')

    return render_template('recolte/edit_recolte.html', 
                         recolte=recolte, 
                         produits=produits, 
                         maraichers=maraichers,
                         today_date=today_date_str,
                         next_week_date=next_week_date,
                         last_week_date=last_week_date)

@app.route('/recolte/edit', methods=['POST'])
def edit_recolte_post():
    mycursor = get_db().cursor()
    id_recolte = request.form.get('ID_recolte', type=int)
    quantite = request.form.get('quantite', type=int)
    date_debut = request.form.get('Date_Debut')
    id_produit = request.form.get('ID_Produit', type=int)
    id_maraicher = request.form.get('ID_Maraicher', type=int)

    check_sql = """
        SELECT * FROM recolte 
        WHERE ID_Maraicher = %s 
        AND ID_recolte != %s 
        AND Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
        AND DATE_ADD(Date_Debut, INTERVAL 7 DAY) > %s
    """
    mycursor.execute(check_sql, (id_maraicher, id_recolte, date_debut, date_debut))    
    existing_recolte = mycursor.fetchone()

    if existing_recolte:
        flash('Ce maraicher a déjà une recolte en cours dans la même semaine', 'error')
        return redirect('/recolte/edit?id=' + str(id_recolte))

    check_sql = """
        SELECT * FROM recolte 
        WHERE ID_Produit = %s 
        AND ID_recolte != %s 
        AND Date_Debut < DATE_ADD(%s, INTERVAL 7 DAY)
        AND DATE_ADD(Date_Debut, INTERVAL 7 DAY) > %s
    """
    mycursor.execute(check_sql, (id_produit, id_recolte, date_debut, date_debut))
    existing_recolte = mycursor.fetchone()

    if existing_recolte:
        flash('Ce produit a déjà une recolte en cours dans la même semaine', 'error')
        return redirect('/recolte/edit?id=' + str(id_recolte))

    sql = """
        UPDATE recolte 
        SET quantite = %s, Date_Debut = %s, ID_Produit = %s, ID_Maraicher = %s
        WHERE ID_recolte = %s
    """
    mycursor.execute(sql, (quantite, date_debut, id_produit, id_maraicher, id_recolte))
    get_db().commit()
    
    flash('Recolte mise à jour avec succès', 'success')
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
        SELECT recolte.*, Produit.nom_produit, Maraicher.Nom, Maraicher.Prenom 
        FROM recolte
        LEFT JOIN Produit ON recolte.ID_Produit = Produit.ID_Produit
        LEFT JOIN Maraicher ON recolte.ID_Maraicher = Maraicher.ID_Maraicher
        WHERE recolte.ID_recolte = %s
    """
    mycursor.execute(sql, (recolte_id,))
    recolte = mycursor.fetchone()
    
    if not recolte:
        flash('Recolte non trouvee', 'error')
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
            'Prenom': recolte['Prenom']
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

@app.route('/etat_recolte', methods=['GET', 'POST'])
def etat_recolte():
    if request.method == 'POST':
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')
        mycursor = get_db().cursor()
        
        sql = """
            SELECT 
                Maraicher.Nom, 
                Maraicher.Prenom, 
                Produit.nom_produit,
                Produit.prix_vente,
                recolte.quantite as quantite,
                (recolte.quantite * Produit.prix_vente) as prix_total
            FROM recolte
            JOIN Maraicher ON recolte.ID_Maraicher = Maraicher.ID_Maraicher
            JOIN Produit ON recolte.ID_Produit = Produit.ID_Produit
            WHERE recolte.Date_Debut BETWEEN %s AND %s
            ORDER BY Maraicher.Nom, Maraicher.Prenom, Produit.nom_produit
        """
        
        mycursor.execute(sql, (start_date, end_date))
        results = mycursor.fetchall()
        
        return render_template('recolte/etat_recolte.html', 
                             results=results,
                             start_date=start_date,
                             end_date=end_date)
    
    return render_template('recolte/etat_recolte.html')

@app.template_filter('to_datetime')
def to_datetime(date_value):
    if not date_value:
        return None
    if isinstance(date_value, str):
        return datetime.strptime(date_value, '%Y-%m-%d')
    if isinstance(date_value, datetime):
        return date_value
    if isinstance(date_value, date):
        return datetime.combine(date_value, datetime.min.time())
    return None

if __name__ == '__main__':
    app.run(debug=True)


