#!/usr/bin/python
# -*- coding:utf-8 -*-
from flask import Flask, request, render_template, redirect, flash

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
            user="constant",
            password="password",
            database="maraichers_db",        # nom de votre base de données
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
def home():
    return render_template('home.html')

@app.route('/maraicher')
def maraicher():
    return render_template('maraicher.html')

@app.route('/recolte')
def recolte():
    return render_template('recolte.html')

@app.route('/produit')
def produit():
    return render_template('produit.html')

@app.route('/marche')
def marche():
    return render_template('marche.html')
if __name__ == '__main__':
    app.run(debug=True)

