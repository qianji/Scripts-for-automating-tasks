# This is a script for setting up AWS EC2 Ubuntu(14.04)-Apache2-PHP(5)-MySQL(5.5) and wordpress(latest)
# to use this script, copy and paste this file, for example name it as setup.sh
# In your terminal, change the file to be executable by running
#   sudo chmod 777 setup.sh
# run the script
#    ./setup.sh

#Those are the tutorials I found to help me set up this script
#http://www.chrishjorth.com/blog/free-aws-ec2-ubuntu-apache-php-mysql-setup/
#https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-ubuntu-14-04
#http://www.templatemonster.com/help/wordpress-troubleshooter-how-to-deal-with-are-you-sure-you-want-to-do-this-error-2.html#gref

# getting updates
sudo apt-get update
sudo apt-get dist-upgrade -y

# install apache2 and php5
sudo apt-get install apache2 -y
sudo a2enmod rewrite
sudo /etc/init.d/apache2 restart
sudo apt-get install libapache2-mod-php5 -y

# install mysql
sudo chown -R www-data:www-data /var/www
sudo chmod -R g+rw /var/www
mysql_root_password="your_password" 
#for example mysql_root_password="123456"
wordpress_database="your_database"
#for example wordpress_database="wordpress"
wordpress_mysql_user="your_user_name"
wordpress_database_password="your_password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"
sudo apt-get install mysql-server -y
sudo apt-get install php5-mysql -y

# create mysql database and user
sudo mysql -u root -p$mysql_root_password -e "CREATE DATABASE $wordpress_database;"
sudo mysql -u root -p$mysql_root_password -e "CREATE USER $wordpress_mysql_user@localhost IDENTIFIED BY '$wordpress_database_password';"
sudo mysql -u root -p$mysql_root_password -e "GRANT ALL PRIVILEGES ON $wordpress_database.* TO $wordpress_mysql_user@localhost;"
sudo mysql -u root -p$mysql_root_password -e "FLUSH PRIVILEGES;"

# get and install wordpress
cd ~
wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
sudo apt-get install php5-gd libssh2-php -y
cd ~/wordpress
sudo cp wp-config-sample.php wp-config.php
sudo rsync -avP ~/wordpress/ /var/www/html/
# change ownership; This is important and takes me a few hours to figure out. www-data is the one apache2 used, so don't change it
sudo chown -R www-data:www-data *
sudo mkdir /var/www/html/wp-content/uploads
sudo chown -R :www-data /var/www/html/wp-content/uploads
sudo chown -R www-data:www-data /var/www
sudo chmod -R g+rw /var/www

# configure apache to allow install wordpress plugins and themes
sudo sed -i '166 s/None/All/' /etc/apache2/apache2.conf
sudo sed -i '$a\define("FS_METHOD", "direct\");' /var/www/html/wp-config.php

# configure php to allow uploading themes or plugins whose size are big, such as 20mb
sudo sed -i '$a\max_execution_time = 180' /etc/php5/apache2/php.ini
sudo sed -i '$a\max_input_time = 600' /etc/php5/apache2/php.ini
sudo sed -i '$a\post_max_size = 128M' /etc/php5/apache2/php.ini
sudo sed -i '$a\upload_max_filesize = 256M' /etc/php5/apache2/php.ini

# configure wordpress to connect to database
sudo sed -i "s/database_name_here/$wordpress_database/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$wordpress_mysql_user/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$wordpress_database_password/" /var/www/html/wp-config.php

#configure to make index.php as default
sudo sed -i "/DirectoryIndex/ s/DirectoryIndex /DirectoryIndex index.php /" /etc/apache2/mods-enabled/dir.conf

sudo /etc/init.d/apache2 restart
