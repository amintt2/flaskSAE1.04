#!/bin/bash

# Fichier de sortie pour enregistrer les IPs répondantes (en format .txt)
output_file="ip-ping-response.txt"

# Vide le fichier de sortie s'il existe déjà
> "$output_file"

# Parcours de la plage d'adresses IP 172.20.20.1 à 172.20.20.254
for i in {1..254}; do
    ip="172.20.20.$i"

    # Tester la connexion à l'IP avec un délai d'attente de 500ms
    ping -c 1 -W 0.1 "$ip" &> /dev/null

    # Vérifier si le ping a réussi
    if [ $? -eq 0 ]; then
        # Afficher l'IP dans le terminal
        echo "IP répondante: $ip"
        
        # Enregistrer l'IP qui a répondu dans le fichier .txt
        echo "$ip" >> "$output_file"
    fi
done

echo "Les adresses IP répondantes ont été enregistrées dans '$output_file'."

# Nom d'utilisateur et mot de passe pour SSH
username="user"
password="disket"

# Vérifier si le fichier d'IP existe
if [ ! -f "$output_file" ]; then
    echo "Le fichier '$output_file' n'existe pas. Veuillez d'abord exécuter le script de ping."
    exit 1
fi

# Lire chaque adresse IP dans le fichier
while IFS= read -r ip; do
    # Ouvrir un terminal Mate pour tester la connexion SSH à l'IP
    mate-terminal -- bash -c "
        echo 'Tentative de connexion à $ip ...';
        sshpass -p '$password' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 $username@$ip 'echo Connexion réussie; exec bash' && echo 'Connexion réussie à $ip' || (echo 'Échec de la connexion à $ip'; exit);
        export DISPLAY=:0;
        firefox --new-window 'https://www.youtube.com/watch?v=U_Wr7TKBnq8&autoplay=1' --kiosk --new-tab 'javascript:document.querySelector(\"video\").requestFullscreen();'
        xrandr --output HDMI-2 --rotate inverted
        sleep 15
        xrandr --output HDMI-2 --rotate normal
    "
    
    # Afficher un message dans le terminal principal pour chaque tentative
    echo "Tentative de connexion à $ip lancée dans un terminal."
done < "$output_file"

echo "Toutes les connexions SSH ont été lancées."