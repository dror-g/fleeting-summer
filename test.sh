#!/bin/sh

OLD_VERSION='3.6.8'
NEW_VERSION='4.0.2'

# clean old dump 
rm -rf ./dump/*

echo "### Starting cluster version $OLD_VERSION ###"
DB_VER=$OLD_VERSION sh init.sh

echo "### Inserting data ###"
docker-compose exec router sh -c "mongo < /scripts/create-collection.js"

echo "### Creating backup ###"
docker-compose exec router sh -c "mongodump"

echo "### Destroying cluster ###"
docker-compose down

echo "### Starting cluster version $NEW_VERSION ###"
DB_VER=$NEW_VERSION sh init.sh

echo "### Restoring data from backup ###"
rm -rf dump/config # Workaround for improper backup of sharded cluster
docker-compose exec router sh -c "mongorestore dump/"
if [ $? -eq 0 ]
then
	echo ""
	echo ""
	echo "### SUCCESS!! ###"
fi

echo "### Verify by searching for doc ###"
docker-compose exec router sh -c "mongo < /scripts/verify-collection.js"
