MongoDB Upgrade Procedure & Considerations
=========================================
As requested, and evaluation of the feasability of a MongoDB v.3 database upgrade to version 4 has been performed.  
The procedure itself is demonstrated using an automated cluster deployment script,  
And the implications of an upgrade are described in this readme document.  


### Test Script
The test procedure uses Docker and docker-compose.  
It creates a V.3 sharded cluster, backs it up, and attempts to restore to a V.4 cluster.  


To start it, run:  
`sh test.sh`  

You can set the desired old/new versions at the top of `test.sh`.

Note!  
The script uses `mongodump` and `mongorestore` to perform the migration,  
However as this is a sharded cluster, this method does not preserve chunk sharding metadata (see workaround to remove `dump/config` folder).  
To perform a full restore of an identical sharded cluster it is required to stop each secondary node (`db.fsyncLock()`) and create an individual backup per-node,  
Then restore each node individually.  


Shareded docker-compose mongo cluster created by [https://github.com/chefsplate/mongo-shard-docker-compose](https://github.com/chefsplate/mongo-shard-docker-compose)
With slight improvements to stability and versioning.

### Implications of Upgrade
Apart for the technical aspect of the upgrade itself it is important to note a few compatibility issues as described [here](https://docs.mongodb.com/manual/release-notes/4.0-compatibility/):

- Removed support for MONGODB-CR:  
Challenge-Response auth mechanism deprecated in favor of SCRAM.
If application relies on CR it must be altered for SCRAM, along with the authentication database itself as described [here](https://docs.mongodb.com/manual/release-notes/3.0-scram/)

- Removed Master-Slave Replication
- Deprecated MMAPv1 Storage Engine

This issues need to be evaluated against our specific usecase.

