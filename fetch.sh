if [ -f  /home/bitnami/htdocs/auto-pull/git-pull-requests/example.org ]
then
rm -f  /home/bitnami/htdocs/auto-pull/git-pull-requests/example.org
cd /srv/shiny-server/sample-apps/data-analysis-shiny/ && sudo git pull
cd /srv/shiny-server/sample-apps/ggcmecon/ && sudo git pull ggcmecon
fi
