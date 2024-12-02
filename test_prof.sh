#!/bin/bash

HOST=localhost
LOGIN=tahar
PASSWORD=
DATABASE=maraicher_db

sed -i '' "s/host=.*/host=\"${HOST}\",/g" app.py
sed -i '' "s/user=.*/user=\"${LOGIN}\",/g" app.py
sed -i '' "s/password=.*/password=\"${PASSWORD}\",/g" app.py
sed -i '' "s/database=.*/database=\"${DATABASE}\",/g" app.py

projet=$(ls -l sql_projet.sql)
if [ $? -ne 0 ]
    then
    echo -e "\033[0;31m \n* pas de fichier sql_projet.sql \033[0m"
    nb_fic_sql=$(ls -l *.sql | wc -l)
    if [ "${nb_fic_sql}" -eq "1" ]
    then
        NOM_FIC_SQL=$(echo *.sql)
        cp "$NOM_FIC_SQL" sql_projet.sql
        echo -e "\033[0;32m \n* fichier copier $NOM_FIC_SQL sql_projet.sql \033[0m"
    else
        echo -e "\033[0;31m \n* pas de fichier ****.sql \033[0m"
        exit 2
    fi  
fi

echo "DROP DATABASE  IF EXISTS ${DATABASE}; CREATE DATABASE ${DATABASE};" | mysql --user=${LOGIN} --password=${PASSWORD} --host=${HOST} ${DATABASE}
mysql --user=${LOGIN} --password=${PASSWORD} --host=${HOST} ${DATABASE} < sql_projet.sql

echo "mysql --user=${LOGIN} --password=${PASSWORD} --host=${HOST} ${DATABASE}" > connect.sh
chmod a+x connect.sh
osascript -e 'tell application "iTerm"
    tell current window
        create tab with default profile
        tell current session
            write text "./connect.sh"
        end tell
    end tell
end tell'

killall python3
flask --debug  --app app  run   --host 0.0.0.0  &
chromium 127.0.0.1:5000