#This is a script for setting up AWS EC2 Ubuntu-Apache-PHP-MySQL and wordpress
sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install apache2 -y

sudo a2enmod rewrite

sudo apt-get install libapache2-mod-php5
sudo /etc/init.d/apache2 restart
sudo adduser ubuntu www-data
sudo chown -R www-data:www-data /var/www
sudo chmod -R g+rw /var/www

sudo apt-get install mysql-server -y
sudo apt-get install php5-mysql -y

sudo apt-get install phpmyadmin -y
