# channel name
CHANNEL_NAME="group2channel"
CHANNEL_TXFILE="/etc/hyperledger/configtx/group2channel.tx"
CHANNEL_BLOCK="group2channel.block"
CHAINCODE_NAME="loc"
CHAINCODE_PATH="loc"
ORDERING_SERVICE_PORT="orderer.group2.com:7050"
CHAINCODE_VERSION="1.0"
#ENDORSER_POLICY='"AND ('"'"'AxisMSP.member'"'"')"'
BUYER_PARAMS="-e CORE_PEER_LOCALMSPID=HondaMSP -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp -e CORE_PEER_ADDRESS=peer0.honda.group2.com:7051"

SELLER_PARAMS="-e CORE_PEER_LOCALMSPID=HeroMSP -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hero.group2.com/users/Admin@hero.group2.com/msp -e CORE_PEER_ADDRESS=peer0.hero.group2.com:7051"

BUYERBANK_PARAMS="-e CORE_PEER_LOCALMSPID=AxisMSP -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axis.group2.com/users/Admin@axis.group2.com/msp -e CORE_PEER_ADDRESS=peer0.axis.group2.com:7051"

SELLERBANK_PARAMS="-e CORE_PEER_LOCALMSPID=EmiritesMSP -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/emirites.group2.com/users/Admin@emirites.group2.com/msp -e CORE_PEER_ADDRESS=peer0.emirites.group2.com:7051"

function create_channel(){
    #create channel
    echo "creating channel" 
    docker exec $BUYER_PARAMS cli peer channel create -o $ORDERING_SERVICE_PORT -c $CHANNEL_NAME -f $CHANNEL_TXFILE
#    docker exec -e "CORE_PEER_LOCALMSPID=HondaMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.honda.group2.com:7051" cli peer channel create -o $ORDERING_SERVICE_PORT -c $CHANNEL_NAME -f $CHANNEL_TXFILE
    sleep 5
    echo "channel created"
}

function join_channel(){
    #JOIN CHANNEL
    echo "buyer joining channel"
    docker exec $BUYER_PARAMS cli peer channel join -b $CHANNEL_BLOCK
#    docker exec -e "CORE_PEER_LOCALMSPID=HondaMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.honda.group2.com:7051" cli peer channel join -b $CHANNEL_BLOCK
    sleep 5
    echo "buyer joinied channel"
    echo "seller joining channel"
    docker exec $SELLER_PARAMS cli peer channel join -b $CHANNEL_BLOCK
#    docker exec -e "CORE_PEER_LOCALMSPID=HeroMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hero.group2.com/users/Admin@hero.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.hero.group2.com:7051" cli peer channel join -b $CHANNEL_BLOCK
    sleep 5
    echo "seller joinied channel"
    echo "buyer bank joining channel"
    docker exec $BUYERBANK_PARAMS cli peer channel join -b $CHANNEL_BLOCK
#    docker exec -e "CORE_PEER_LOCALMSPID=AxisMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axis.group2.com/users/Admin@axis.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.axis.group2.com:7051" cli peer channel join -b $CHANNEL_BLOCK
    sleep 5
    echo "buyer bank joinied channel"
    echo "seller bank joining channel"
    docker exec $SELLERBANK_PARAMS cli peer channel join -b $CHANNEL_BLOCK
#    docker exec -e "CORE_PEER_LOCALMSPID=EmiritesMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/emirites.group2.com/users/Admin@emirites.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.emirites.group2.com:7051" cli peer channel join -b $CHANNEL_BLOCK
    sleep 5
    echo "seller bank joinied channel"
}

function install_channel(){
    #install chaincode
    echo "buyer installing chaincode"
    docker exec $BUYER_PARAMS cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
#    docker exec -e "CORE_PEER_LOCALMSPID=HondaMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.honda.group2.com:7051" cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
    sleep 5
    echo "buyer installed chaincode"
    echo "seller  installing chaincode"
    docker exec $SELLER_PARAMS cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
#   docker exec -e "CORE_PEER_LOCALMSPID=HeroMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hero.group2.com/users/Admin@hero.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.hero.group2.com:7051" cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
    sleep 5
    echo "seller installed chiancode"
    echo "buyer bank installing chaincode"
    docker exec $BUYERBANK_PARAMS cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
#   docker exec -e "CORE_PEER_LOCALMSPID=AxisMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/axis.group2.com/users/Admin@axis.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.axis.group2.com:7051" cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
    sleep 5
    echo "buyer bank installed chiancode"
    echo "seller bank installing chaincode"
    docker exec $SELLERBANK_PARAMS cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
#   docker exec -e "CORE_PEER_LOCALMSPID=EmiritesMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/emirites.group2.com/users/Admin@emirites.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.emirites.group2.com:7051" cli peer chaincode install -n $CHAINCODE_NAME -v $CHAINCODE_VERSION -p $CHAINCODE_PATH -l golang
    sleep 5
    echo "seller bank installed chiancode"
}

function instantiate_chaincode(){
    #INSTANTIATE CHAINCODE
    echo "instantiating chaincode"
    docker exec $BUYER_PARAMS cli peer chaincode instantiate -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -l golang -v $CHAINCODE_VERSION -c '{"Args":[""]}' -P "AND ('HondaMSP.member')"
#    docker exec -e "CORE_PEER_LOCALMSPID=HondaMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.honda.group2.com:7051" cli peer chaincode instantiate -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -l golang -v $CHAINCODE_VERSION -c '{"Args":[""]}' -P "AND ('HondaMSP.member')"
    sleep 5
    echo "intantiated chaincode"
}

function upgrade_chaincode(){
    #UPGRADE CHAINCODE
    echo "Upgrading chaincode"
    docker exec $BUYER_PARAMS cli peer chaincode upgrade -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -l golang -v $CHAINCODE_VERSION -c '{"Args":[""]}' -P "AND ('HondaMSP.member')"
#    docker exec -e "CORE_PEER_LOCALMSPID=HondaMSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/honda.group2.com/users/Admin@honda.group2.com/msp" -e "CORE_PEER_ADDRESS=peer0.honda.group2.com:7051" cli peer chaincode upgrade -o $ORDERING_SERVICE_PORT -C $CHANNEL_NAME -n $CHAINCODE_NAME -l golang -v $CHAINCODE_VERSION -c '{"Args":[""]}' -P "AND ('HondaMSP.member')"
    sleep 5
    echo "intantiated chaincode"
}

function printHelp () {
  echo "Usage: "
  echo "  setup.sh create|join|install|intantiate|upgrade|all [-v <chain code version>]"
  echo "  setup.sh -h|--help (print this message)"
}

# Ask user for confirmation to proceed
function askProceed () {
  read -p "Continue? [Y/n] " ans
  case "$ans" in
    y|Y|"" )
      echo "proceeding ..."
    ;;
    n|N )
      echo "exiting..."
      exit 1
    ;;
    * )
      echo "invalid response"
      askProceed
    ;;
  esac
}

MODE=$1;shift
# Determine whether starting, stopping, restarting or generating for announce
if [ "$MODE" == "create" ]; then
  EXPMODE="Creating channel"
elif [ "$MODE" == "join" ]; then
  EXPMODE="Joining channel"
elif [ "$MODE" == "install" ]; then
  EXPMODE="Installing chaincode"
elif [ "$MODE" == "instantiate" ]; then
  EXPMODE="Instantiating chaincode"
elif [ "$MODE" == "upgrade" ]; then
  EXPMODE="upgrading chaincode"
elif [ "$MODE" == "all" ]; then
  EXPMODE="Creating channel, Joining channel, Installing chaincode and Instantiating chiancode"
else
  printHelp
  exit 1
fi

while getopts "h?m:v:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    v)  CHAINCODE_VERSION=$OPTARG
    ;;
  esac
done

# Announce what was requested
echo "${EXPMODE} with version '${CHAINCODE_VERSION}'"
# ask for confirmation to proceed
askProceed

#Create the network using docker compose
echo "starting setup"

if [ "${MODE}" == "all" ]; then
    create_channel
    join_channel
    install_channel
    instantiate_chaincode
elif [ "${MODE}" == "create" ]; then 
    create_channel
elif [ "${MODE}" == "join" ]; then 
    join_channel
elif [ "${MODE}" == "install" ]; then 
    install_channel
elif [ "${MODE}" == "instantiate" ]; then 
    instantiate_chaincode
elif [ "${MODE}" == "upgrade" ]; then 
	upgrade_chaincode
else
  printHelp
  exit 1
fi

echo "setup complete"

docker ps
##docker exec -it cli bash
#
##docker-compose up ca0.group2.com orderer.group2.com peer0.honda.group2.com cli
