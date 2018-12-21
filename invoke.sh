CHANNEL_NAME="group2channel"
CHAINCODE_NAME="loc"
ORDERING_SERVICE_PORT="orderer.group2.com:7050"
BUYER_PARAMS="-e CORE_PEER_LOCALMSPID=HondaMSP -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp -e CORE_PEER_ADDRESS=peer0.honda.group2.com:7051"

#docker exec $BUYER_PARAMS cli peer chaincode invoke -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"function":"acceptLC","Args":["loc4"]}'

docker exec $BUYER_PARAMS cli peer chaincode invoke -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"function":"issueLC","Args":["loc8","25122019","24122018"]}'

#docker exec $BUYER_PARAMS cli peer chaincode invoke -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"function":"read","Args":["loc4"]}'

#docker exec $BUYER_PARAMS cli peer chaincode invoke -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"function":"requestLC","Args":["loc1","21","Test Product","23","14","","","Honda","hyd","Axis","TVS","Chennai","Axis","Chennai","Hyd","100","12"]}'

#docker exec $BUYER_PARAMS cli peer chaincode invoke -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"function":"acceptLC","Args":["loc1","21","Test Product","23","14","","","Honda","hyd","Axis","TVS","Chennai","Axis","Chennai","Hyd","100","12"]}'
