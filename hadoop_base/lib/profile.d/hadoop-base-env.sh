export HADOOP_PREFIX=/usr/hadoop/latest
export HADOOP_LIBEXEC_DIR=$HADOOP_PREFIX/libexec
export PATH=$PATH:$HADOOP_PREFIX/bin
. $HADOOP_PREFIX/env/hadoop-env.sh
. $HADOOP_PREFIX/env/yarn-env.sh
