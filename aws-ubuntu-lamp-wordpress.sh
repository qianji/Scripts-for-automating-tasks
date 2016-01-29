#This is a script for setting up AWS EC2 Ubuntu-Apache-PHP-MySQL and wordpress

#http://www.chrishjorth.com/blog/free-aws-ec2-ubuntu-apache-php-mysql-setup/

sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install apache2 -y

sudo a2enmod rewrite
sudo /etc/init.d/apache2 restart

sudo apt-get install libapache2-mod-php5 -y
sudo chown -R www-data:www-data /var/www
sudo chmod -R g+rw /var/www
#https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04
mysql_root_password="your_password"
wordpress_database="your_database"
wordpress_mysql_user="your_user_name"
wordpress_database_password="your_password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"
sudo apt-get install mysql-server -y
sudo apt-get install php5-mysql -y

#sudo apt-get install phpmyadmin -y

sudo mysql -u root -p$mysql_root_password -e "CREATE DATABASE $wordpress_database;"
sudo mysql -u root -p$mysql_root_password -e "CREATE USER $wordpress_mysql_user@localhost IDENTIFIED BY '$wordpress_database_password';"
sudo mysql -u root -p$mysql_root_password -e "GRANT ALL PRIVILEGES ON $wordpress_database.* TO $wordpress_mysql_user@localhost;"
sudo mysql -u root -p$mysql_root_password -e "FLUSH PRIVILEGES;"

cd ~
wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz

sudo apt-get install php5-gd libssh2-php -y
cd ~/wordpress
sudo cp wp-config-sample.php wp-config.php
sudo rsync -avP ~/wordpress/ /var/www/html/
sudo chown -R www-data:www-data *
sudo mkdir /var/www/html/wp-content/uploads
sudo chown -R :www-data /var/www/html/wp-content/uploads
sudo chown -R www-data:www-data /var/www
sudo chmod -R g+rw /var/www

# modifying files

sudo sed -i '166 s/None/All/' /etc/apache2/apache2.conf
#add to wp-config.php
#define('FS_METHOD', 'direct');
sudo sed -i '$a\define("FS_METHOD", "direct\");' /var/www/html/wp-config.php

sudo sed -i '$a\max_execution_time = 180' /etc/php5/apache2/php.ini
sudo sed -i '$a\max_input_time = 600' /etc/php5/apache2/php.ini
sudo sed -i '$a\post_max_size = 128M' /etc/php5/apache2/php.ini
sudo sed -i '$a\upload_max_filesize = 256M' /etc/php5/apache2/php.ini

sudo sed -i "s/database_name_here/$wordpress_database/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$wordpress_mysql_user/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$wordpress_database_password/" /var/www/html/wp-config.php

sudo sed -i "/DirectoryIndex/ s/DirectoryIndex /DirectoryIndex index.php /" /etc/apache2/mods-enabled/dir.conf


sudo /etc/init.d/apache2 restart
#http://www.templatemonster.com/help/wordpress-troubleshooter-how-to-deal-with-are-you-sure-you-want-to-do-this-error-2.html#gref

# add to the end of php.ini
# max_execution_time = 180
# max_input_time = 600
# post_max_size = 128M
# upload_max_filesize = 256M
