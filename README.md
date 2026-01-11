# Lab de Sécurité - Activité 1 : Audit & Mouvement Latéral

## Présentation
Ce dépôt contient le script de configuration automatique d'un serveur **Ubuntu 22.04 LTS** vulnérable. 
Il simule un serveur de développement de la société **Baretto-Labs** déployé sans durcissement.

## Déploiement
1. Cloner le dépôt : `git clone <ton-repo-url>`
2. Donner les droits : `chmod +x setup_vuln_lab.sh`
3. Exécuter : `sudo ./setup_vuln_lab.sh`

## Vulnérabilités présentes (Objectifs de l'Audit)
1. **Web (RCE) :** Le fichier `/var/www/html/status.php` permet l'exécution de commandes système via le paramètre URL `?service=`.
2. **Système (PrivEsc) :** L'utilisateur `www-data` possède des droits sudo sur `/usr/bin/find`. (Technique de contournement GTFOBins).
3. **Accès (SSH) :** Le login Root est autorisé avec mot de passe (Vulnérable au bruteforce).
4. **Information Leakage :** Les bannières Nginx et PHP sont visibles (divulgation de version).
## Nouvelles vulnérabilités identifiées pour l'Audit (Activité 1)

### 5. Politique de mots de passe (Faiblesse d'authentification)
- **Constat :** L'utilisateur `mehdi` utilise un mot de passe présent dans le top des listes de dictionnaires (`Password1`).
- **Risque :** Compromission de compte via brute-force SSH ou credential stuffing.
- **Outil d'audit conseillé :** `hydra -l mehdi -P /usr/share/wordlists/rockyou.txt ssh://<IP_SERVEUR>`

### 6. Escalade de privilèges via Sudo
- **Constat :** L'utilisateur `mehdi` peut exécuter `/usr/bin/find` avec les droits Root sans mot de passe.
- **Risque :** Prise de contrôle totale du serveur (Privilege Escalation).

## Scénario de test
- **Étape 1 :** Scan Nmap depuis Kali pour trouver le port 80.
- **Étape 2 :** Exploitation RCE : `?service=nginx; id`.
- **Étape 3 :** Escalade vers Root via le binaire `find`.# security-lab