COMPOSE_FILE="docker-compose.yaml"
CA_SERVICES="ca0.group2.com ca1.group2.com ca2.group2.com ca3.group2.com"
COUCHDB_SERVICES="couchdb0 couchdb1 couchdb2 couchdb3"
PEER_SERVICES="peer0.honda.group2.com peer0.hero.group2.com peer0.axis.group2.com peer0.emirites.group2.com"
ORDERER_SERVICES="orderer.group2.com"
CLI_SERVICES="cli"

docker-compose -f $COMPOSE_FILE up -d $CA_SERVICES $COUCHDB_SERVICES $ORDERER_SERVICES $PEER_SERVICES $CLI_SERVICES

#docker-compose -f $COMPOSE_FILE up -d ca0.group2.com couchdb0 orderer.group2.com peer0.honda.group2.com cli

sleep 30

docker ps

echo "Network started"

