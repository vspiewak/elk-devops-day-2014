Elastisearch multi nodes sample
===============================

for i in $(seq 1 10); do curl -XPOST localhost:9200/my_index/my_type -d "{ \"value\": $i}" ; done
