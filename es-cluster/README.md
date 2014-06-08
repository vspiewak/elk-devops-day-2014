Elasticsearch Cluster
=====================

Browse
------

    http://localhost:19200/_plugin/head
    http://localhost:19200/_plugin/bigdesk
    http://localhost:19200/_plugin/paramedic
    http://localhost:19200/_plugin/HQ


Configuration
-------------

    grep -v '^#' elasticsearch.node* | grep ' '


Insert datas
------------

    n=10; i=0; while [ $i -lt $n ]; do i=$(( $i + 1 )); curl -XPOST localhost:19200/my_store/products/$i -d '{ "productRef": "'`uuidgen`'", "price": '$(((RANDOM%100)+1))' }'; done


Change Replicas
---------------

    curl -XPUT 'localhost:19200/my_store/_settings' -d '
        {
            "index" : { "number_of_replicas" : 2 }
        }'


Shutdown / Restart
------------------

    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-1/_shutdown'
    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-2/_shutdown'
    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-3/_shutdown'
    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-4/_shutdown'
    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-5/_shutdown'
    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-6/_shutdown'
    curl -XPOST 'http://localhost:19200/_cluster/nodes/*-7/_shutdown'

    ssh -c "sudo /home/vagrant/es-node1/bin/elasticsearch"
    ssh -c "sudo /home/vagrant/es-node2/bin/elasticsearch"
    ssh -c "sudo /home/vagrant/es-node3/bin/elasticsearch"
    ssh -c "sudo /home/vagrant/es-node4/bin/elasticsearch"
    ssh -c "sudo /home/vagrant/es-node5/bin/elasticsearch"
    ssh -c "sudo /home/vagrant/es-node6/bin/elasticsearch"
    ssh -c "sudo /home/vagrant/es-node7/bin/elasticsearch"
