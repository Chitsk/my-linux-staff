#!/bin/bash
#PHPIPAM default login
# username : admin
# Password: ipamadmin

#reference https://computingforgeeks.com/install-and-configure-phpipam-on-ubuntu-debian-linux/
DATABASE_PASS='Pass-2024'
sudo apt update
sud apt install -y curl git vim

sudo apt install mariadb-server mariadb-client -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "CREATE DATABASE phpipam"
sudo mysql -u root -p"$DATABASE_PASS" -e "GRANT ALL ON phpipam.* TO phpipam@localhost IDENTIFIED BY 'Pass-2024'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

sudo systemctl restart mariadb

sudo apt update 
sudo apt -y install php php-{mysql,curl,gd,intl,pear,imap,memcache,pspell,tidy,xmlrpc,mbstring,gmp,json,xml,fpm}


sudo git clone --recursive https://github.com/phpipam/phpipam.git /var/www/html/phpipam

cd /var/www/html/phpipam

cp config.dist.php config.php

#edited config.php file
sudo sed -i 's/phpipamadmin/Pass-2024/' config.php
sudo apt -y install apache2

sudo a2dissite 000-default.conf
sudo systemctl reload apache2
sudo a2enmod rewrite
sudo systemctl restart apache2

sudo apt -y install libapache2-mod-php php-curl php-xmlrpc php-intl php-gd

cd /etc/apache2/sites-available/

cat <<EOT > phpipam.conf
#add below
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot "/var/www/html/phpipam"
    ServerName ipam.example.com
    ServerAlias www.ipam.example.com
    <Directory "/var/www/html/phpipam">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog "/var/log/apache2/phpipam-error_log"
    CustomLog "/var/log/apache2/phpipam-access_log" combined
</VirtualHost>

EOT

chown -R www-data:www-data /var/www/html
sudo a2ensite phpipam
sudo systemctl reload apache2

sudo systemctl restart apache2


#localhost:80 in browser
#New phpipam installation“

#automatic installation



