Elastisearch multi nodes sample
===============================

for i in $(seq 1 10); do echo '{ "index": { "_index": "my_store", "_type": "products", "_id": '$i' } }'; echo '{ "productRef": "'`uuidgen`'", "price": '$(((RANDOM%100)+1))' }'; done > bulk.json
curl -XPOST localhost:9200/_bulk --data-binary @bulk.json

