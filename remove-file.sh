#!/bin/sh
# Script de suppression automatique pour le projet Argus (AIS 2026)

# On lit le JSON envoyé par Wazuh sur l'entrée standard
# On cherche le champ "file" qui contient le chemin (vu dans le JSON de l'alerte)
read INPUT
FILE_PATH=$(echo $INPUT | grep -oP '"file":"\K[^"]+')

if [ -n "$FILE_PATH" ]; then
    # Action de remédiation
    rm -f "$FILE_PATH"
    # Log de l'action pour preuve dans le Dossier Professionnel
    echo "$(date) [ACTION AIS] Suppression automatique de : $FILE_PATH" >> /var/ossec/logs/active-responses.log
fi
