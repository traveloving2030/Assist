#chaincode insall

docker exec cli peer chaincode install -n PrivateGene -v 1.2 -p github.com/PriveateGene
docker exec cli peer chaincode instantiate -n PrivateGene -v 1.0 -C battery -c '{"Args":["init"]}' -P 'OR ("Org1MSP.member", "Org2MSP.member")' --collections-config  /opt/gopath/src/github.com/PriveateGene/collections_config.json 
docker exec cli peer chaincode upgrade -n PrivateGene -v 1.2 -p -C battery github.com/PriveateGene
docker exec cli peer chaincode upgrade -n mycc -v 1 -c '{"Args":["d", "e", "f"]}' -C battery
docker exec cli peer chaincode install -n PrivateGene -v 1.1 -p github.com/PriveateGene
docker exec cli peer chaincode upgrade -n PrivateGene -v 1.2 -C battery -c '{"Args":["init"]}' -P 'OR ("Org1MSP.member", "Org2MSP.member")' --collections-config  /opt/gopath/src/github.com/PriveateGene/collections_config.json 

#chaincode instatiate
docker exec cli peer chaincode instantiate -n mym -v 1.0 -C battery -c '{"Args":["a","100"]}' -P 'OR ("Org1MSP.member", "Org2MSP.member","Org3MSP.member")' --collections-config  /opt/gopath/src/github.com/mymarbles/collections_config.json 
sleep 5
export MARBLE=$(echo -n "{\"Id\":\"4\",{\"Skin.Aging\":22,\"Skin.Elasticity\":22,\"Skin.Aging\":22}}" | base64)
export MARBLE=$(echo -n "{\"Id\":\"4\","\Skin{\"Aging\":22,\"Elasticity\":35,\"Aging\":33}\"}"" | base64 | tr -d \\n)

export MARBLE=$(echo -n "{"Id":"4","{"Skin":"["Aging":33,"Elasticity":33,"Pigmentation":33]"}}"" | base64 | tr -d \\n)
docker exec cli peer chaincode invoke -o orderer.example.com:7050 -n PrivateGene -C battery -c '{"Args":["saveskininfo"]}'  --transient "{\"putPrivateGene\":\"$MARBLE\"}"
docker exec cli peer chaincode query -C battery -n PrivateGene -c '{"Args":["getskininfo","3"]}'

#chaincode invoke init marble1
export MARBLE=$(echo -n "{\"name\":\"marble1\",\"color\":\"blue\",\"size\":35,\"owner\":\"tom\",\"price\":99}" | base64 | tr -d \\n)
docker exec cli peer chaincode invoke -o orderer.example.com:7050 -n mym -C battery -c '{"Args":["initMarble"]}'  --transient "{\"marble\":\"$MARBLE\"}"
sleep 5

#chaincode query 
docker exec cli peer chaincode query -C battery -n mym -c '{"Args":["readMarble","marble1"]}'

echo '-------------------------------------END-------------------------------------'
