#!/bin/bash

DATABASE_PASS='Pass-2024'
sudo apt update
sud apt install -y curl vim


wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
apt update

sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y


sudo apt install mysql-server -y

sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database zabbix character set utf8mb4 collate utf8mb4_bin"
sudo mysql -u root -p"$DATABASE_PASS" -e "create user zabbix@localhost identified by 'Pass-2024'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on zabbix.* to zabbix@localhost"
sudo mysql -u root -p"$DATABASE_PASS" -e "set global log_bin_trust_function_creators = 1"

echo ""
echo "--------------------------------------------------------"
echo ""
echo "Zabbix server host is importing initial schema and data!!!"
echo ""
echo "--------------------------------------------------------"
echo ""

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -pPass-2024 zabbix
echo ""
echo "--------------------------------------------------------"
echo ""
echo "Zabbix server host finished initial schema and data!!!"
echo ""
echo "--------------------------------------------------------"
echo ""
sleep 2s

sudo mysql -u root -p"$DATABASE_PASS" -e "set global log_bin_trust_function_creators = 0"

sudo sed -i 's/=password/=Pass-2024/' /etc/zabbix/zabbix_server.conf

sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2
sudo service zabbix-server status
IP_Address=$(hostname -I)
echo ""
echo "--------------------------------------------------------"
echo ""
echo "Zabbix server installation completed and you can accesss at http://$IP_Address/zabbix"
echo "Default username: Admin"
echo "Default password: zabbix"
echo ""
echo "--------------------------------------------------------"
echo ""
