http://www.chrishjorth.com/blog/free-aws-ec2-ubuntu-apache-php-mysql-setup/
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

#sudo apt-get install phpmyadmin -y

sudo mysql -u root -p123456 -e "CREATE DATABASE wordpress;"
sudo mysql -u root -p123456 -e "CREATE USER wordpressuser@localhost IDENTIFIED BY 'password';"
sudo mysql -u root -p123456 -e "GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost;"
sudo mysql -u root -p123456 -e "FLUSH PRIVILEGES;"

cd ~
wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz

sudo apt-get install php5-gd libssh2-php
cd ~/wordpress
cp wp-config-sample.php wp-config.php
sudo rsync -avP ~/wordpress/ /var/www/html/
sudo chown -R ubuntu:www-data *
mkdir /var/www/html/wp-content/uploads
sudo chown -R :www-data /var/www/html/wp-content/uploads

