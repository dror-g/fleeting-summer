#!/bin/bash

# Create shards
docker-compose up -d
sleep 5
docker-compose exec config01 sh -c "mongo --port 27017 < /scripts/init-configserver.js"
docker-compose exec shard01a sh -c "mongo --port 27018 < /scripts/init-shard01.js"
docker-compose exec shard02a sh -c "mongo --port 27019 < /scripts/init-shard02.js"
docker-compose exec shard03a sh -c "mongo --port 27020 < /scripts/init-shard03.js"

# Add shards to router, retry till ready
while true
do
	sleep 5
	docker-compose exec router sh -c "mongo < /scripts/init-router.js"
	if [ $? -eq 0 ]
	then
		break
	fi
	echo "### It's cool, retrying in 5 seconds.. ###" 
done
