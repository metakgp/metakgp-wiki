source .env
docker cp $1 metakgpwikidocker_mysql_1:metakgp_wiki_db.sql
docker-compose exec mysql sh -c 'mysql -u metakgp_user -p'$MYSQL_PASSWORD' metakgp_wiki_db < metakgp_wiki_db.sql'
