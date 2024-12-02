#!/bin/bash

echo "🚀 Vérification de l'environnement..."

# Debug mode pour voir toutes les commandes exécutées
set -x

if [ -d "venv" ]; then
    echo "✅ L'environnement virtuel existe"
else
    echo "❌ L'environnement virtuel n'existe pas"
    exit 1
fi

echo "Test 1"

source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'activation de l'environnement"
    exit 1
fi

echo "Test 2"

# Configuration explicite des variables d'environnement Flask
export FLASK_APP=app.py
export FLASK_ENV=development
export FLASK_DEBUG=1

# Installation des dépendances depuis requirements.txt
echo "📦 Installation des dépendances..."
pip install --upgrade pip

# Installation spécifique de cryptography d'abord
echo "📦 Installation de cryptography..."
pip install -v --no-cache-dir cryptography==42.0.5

# Vérification de l'installation de cryptography
if ! python -c "import cryptography" &> /dev/null; then
    echo "❌ Erreur: cryptography n'est pas correctement installé"
    exit 1
fi

echo "📦 Installation des dépendances depuis requirements.txt..."
# Ajout de -v pour plus de verbosité et --no-cache-dir pour éviter les problèmes de cache
pip install -v --no-cache-dir -r requirements.txt

echo "🌱 Lancement du serveur Flask sur http://localhost:5000"
python3 -m flask run --debug --host=0.0.0.0 --port=5000 2>&1

echo "Test 3"
