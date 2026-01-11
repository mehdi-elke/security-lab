#!/bin/bash

# Script de déploiement du Lab Vulnérable v2 - Titre AIS
# Ajout : Utilisateur Mehdi avec mot de passe faible

# 1. Mise à jour et installation des paquets
echo "[*] Installation de Nginx, PHP et outils de base..."
sudo apt update && sudo apt install -y nginx php-fpm git

# 2. Création du script PHP vulnérable (RCE)
echo "[*] Injection de la faille applicative (status.php)..."
cat <<EOF | sudo tee /var/www/html/status.php
<?php
  \$service = \$_GET['service'] ?? 'nginx';
  echo "<h1>Statut du service : " . htmlspecialchars(\$service) . "</h1>";
  echo "<pre>";
  echo shell_exec("systemctl status " . \$service);
  echo "</pre>";
?>
EOF

# 3. Configuration SSH permissive
echo "[*] Configuration SSH permissive..."
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# 4. Faille Sudo pour l'élévation de privilèges
# On donne le droit à mehdi (ou www-data) d'utiliser find
echo "mehdi ALL=(ALL) NOPASSWD: /usr/bin/find" | sudo tee /etc/sudoers.d/mehdi-sudo

# 5. Finalisation
sudo systemctl restart nginx
echo "[+] Setup v2 terminé !"
echo "[!] IP du serveur : \$(hostname -I | awk '{print \$1}')"