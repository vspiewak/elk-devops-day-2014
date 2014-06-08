Feedbacks
---------
* The Guardian: process social network data to provide real time feedback on article
* StackOverflow use full text search with geolocation queries and "more like this" feature
* Goldman Sachs: 5TB log by day + analyze stock market movements
* Rockstars: ELK for BI on business datas


Relational / ES
---------------

Relational	DB		Table		Row		Column
ES		Indices		Types		Document	Field


Node Types
----------
1. You want this node to never become a master node, only to hold data.
   This will be the "workhorse" of your cluster.

node.master: false
node.data: true

2. You want this node to only serve as a master: to not store any data and
   to have free resources. This will be the "coordinator" of your cluster.

node.master: true
node.data: false

3. You want this node to be neither master nor data node, but
   to act as a "search load balancer" (fetching data from nodes, aggregating results, etc.)

node.master: false
node.data: false


Shards / Replicas
-----------------
1. Having more *shards* enhances the _indexing_ performance and allows to _distribute_ a big index across machines.
2. Having more *replicas* enhances the _search_ performance and improves the cluster _availability_.

The "number_of_shards" is a one-time setting for an index.
The "number_of_replicas" can be increased or decreased anytime, by using the Index Update Settings API.


Health
------

* green 	primary / replica shards active
* yellow 	all primary but not all replicas 
* red		not all primary shards are running

Search
------
/_search			all types in all indices
/gb/_search			all types in gb index
/gb,us/_search			all types in gb & us indices
/g*,u*/_search			all types in any indices beginning with g or u
/gb/user/_search		type user un gb index
/gb,us/user,tweet/_search	types user & tweet in the gb and us indices
/_all/user,tweet/_search	search types user and tweet in all indices

Pagination
----------
GET /_search?size=5
GET /_search?size=5&from=5
GET /_search?size=5&from=10

Zero downtime
-------------
POST /_aliases
    {
        "actions": [
            { "remove": { "index": "my_index_v1", "alias": "my_index" }},
            { "add":    { "index": "my_index_v2", "alias": "my_index" }}
] }


http://www.cubrid.org/blog/dev-platform/our-experience-creating-large-scale-log-search-system-using-elasticsearch/
