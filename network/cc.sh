#chaincode insall
docker exec cli peer chaincode install -n genedata -v 1.0 -p github.com/genedata
docker exec cli peer chaincode install -n genedata -v 1.1 -p github.com/genedata
docker exec cli peer chaincode upgrade -n genedata -v 1.0 -C battery -c '{"Args":["init"]}' -P 'OR ("Org1MSP.member", "Org2MSP.member")'
#chaincode instatiate
docker exec cli peer chaincode instantiate -n genedata -v 1.0 -C battery -c '{"Args":["Init"]}' -P 'OR ("Org1MSP.member", "Org2MSP.member")'
sleep 5
#chaincode query a
docker exec cli peer chaincode query -n genedata -C battery -c '{"Args":["getGene","a"]}'

docker exec cli peer chaincode invoke -n genedata -C battery -c '{"Args":["addUser","a"]}'
#chaincode invoke b
docker exec cli peer chaincode query -n genedata -C battery -c '{"Args":["getUser","a"]}'



docker exec cli peer chaincode invoke -n genedata -C battery -c '{"Args":["addGene","b","1111","1222","333"]}'
sleep 5
#chaincode query b
docker exec cli peer chaincode query -n genedata -C battery -c '{"Args":["getGene","4"]}'

echo '-------------------------------------END-------------------------------------'
