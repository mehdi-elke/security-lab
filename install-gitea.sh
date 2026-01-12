#!/bin/bash

# =================================================================
# Script d'installation automatisée de Gitea
# =================================================================

# 1. Variables de configuration
GITEA_VERSION="1.21.4"
GITEA_BINARY_URL="https://dl.gitea.com/gitea/${GITEA_VERSION}/gitea-${GITEA_VERSION}-linux-amd64"
GITEA_USER="git"

echo "Début de l'installation de Gitea v${GITEA_VERSION}..."

# 2. Mise à jour et dépendances
sudo apt update && sudo apt install -y git wget

# 3. Vérification de l'utilisateur 'git'
if id "$GITEA_USER" &>/dev/null; then
    echo "L'utilisateur '$GITEA_USER' existe déjà, on continue."
else
    echo "Création de l'utilisateur système '$GITEA_USER'..."
    sudo adduser --system --group --disabled-password --shell /bin/bash --home /home/git git
fi

# 4. Création de l'arborescence (Standard FHS)
echo "Création des répertoires..."
sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo mkdir -p /etc/gitea

# 5. Téléchargement du binaire
echo "Téléchargement de Gitea..."
sudo wget -O /usr/local/bin/gitea ${GITEA_BINARY_URL}
sudo chmod +x /usr/local/bin/gitea

# 6. Gestion des permissions
echo "Configuration des permissions..."
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea

# 7. Création du service Systemd
echo "Configuration du service Systemd..."
cat <<EOF | sudo tee /etc/systemd/system/gitea.service
[Unit]
Description=Gitea (Git with a cup of tea)
After=network.target

[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
EOF

# 8. Lancement du service
echo "Démarrage de Gitea..."
sudo systemctl daemon-reload
sudo systemctl enable --now gitea

echo "Installation terminée !"
echo "Accède à l'interface via : http://localhost:3000"