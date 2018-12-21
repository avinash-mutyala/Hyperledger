COMPOSE_FILE="docker-compose.yaml"

docker-compose -f $COMPOSE_FILE down

echo "network is down"

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

#docker volume rm $(docker volume ls -q)

docker ps -a
