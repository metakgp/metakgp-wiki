source .env
docker-compose cp $1 mysql:metakgp_wiki_db.sql
docker-compose exec mysql sh -c 'mysql -u metakgp_user -p'$MYSQL_PASSWORD' metakgp_wiki_db < metakgp_wiki_db.sql'
