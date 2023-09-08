docker compose down
# warning: will remove all unused volumes!
docker volume ls | awk '{print $2}' | xargs docker volume rm
docker compose up --build
