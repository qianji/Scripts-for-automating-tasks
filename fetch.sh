sudo rm -f  /var/www/html/auto-pull/git-pull-requests/example.org
#sudo rm -rf /srv/shiny-server/data-analysis-shiny/
#sudo rm -rf /srv/shiny-server/ggcmecon/
cd /srv/shiny-server/data-analysis-shiny/
#sudo git clone https://github.com/mrbsoftisms/ggcmecon.git
sudo git pull
cd /srv/shiny-server/ggcmecon/
#sudo git clone https://github.com/qianji/data-analysis-shiny.git
sudo git pull
cd /srv/shiny-server/Scripts-for-automating-tasks/
sudo git pull
fi
