#!/bin/bash

echo "🚀 Vérification de l'environnement..."

# Fonction pour trouver l'environnement virtuel existant
find_venv() {
    for dir in */ .*/ ; do
        if [ -f "${dir}bin/activate" ]; then
            echo "${dir}"
            return 0
        fi
    done
    return 1
}

# Vérification si un environnement virtuel est déjà activé
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "✅ L'environnement virtuel est déjà activé dans: $VIRTUAL_ENV"
    
    # Désactivation de l'environnement actuel
    echo "🔄 Désactivation de l'environnement actuel..."
    deactivate 2>/dev/null || true
fi

# Vérification si l'environnement virtuel existe
if [ -d "venv" ]; then
    if [ -f "venv/bin/activate" ]; then
        echo "✅ L'environnement virtuel existe"
        echo "🔄 Activation de l'environnement..."
        source venv/bin/activate
    else
        echo "❌ L'environnement virtuel semble corrompu"
        echo "🔄 Recréation de l'environnement..."
        python3 -m venv venv
        source venv/bin/activate
        pip install -r requirements.txt
    fi
else
    echo "⚙️  Création de l'environnement virtuel..."
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
fi

# Lancement de l'application Flask en mode debug
echo "🌱 Lancement du serveur Flask..."
flask run --debug 