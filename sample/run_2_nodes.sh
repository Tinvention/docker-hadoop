########
# Before running this script one should first create the mock.cluster.net bridge network.
# Also make sure that the mock.cluster.net subnet is 172.18.0.0/16
##
# docker network create --driver bridge mock.cluster.net

docker run -d --network mock.cluster.net --name master -h mn01 --network-alias mn01 hadoop_node
docker run -d --network mock.cluster.net --name slave -h dn01 --network-alias dn01 hadoop_node

########
# To start the cluster log into the master node and run the following
##
# hdfs@master$ hdfs namenode -format cluster1 &&\
# hdfs@master$ sh $HADOOP_PREFIX/sbin/start-dfs.sh &&\
# yarn@master$ sh $HADOOP_PREFIX/sbin/start-yarn.sh

# Browse to the following urls to check the cluster status
#
# http://172.18.0.2:50070     ->     dfs health
# http://172.18.0.3:8042      ->     datanode
# 
