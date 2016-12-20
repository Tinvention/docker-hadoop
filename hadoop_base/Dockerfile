FROM centos:centos7

ADD lib/java/oracle/jdk8/jdk-8u112-linux-x64.tar.gz /opt/java/lib/
ADD lib/hadoop/hadoop-2.7.3/hadoop-2.7.3.tar.gz /opt/hadoop/lib/

COPY lib/hadoop/env/* /tmp/env/
COPY lib/hadoop/conf/* /tmp/conf/
COPY lib/profile.d/* /tmp/profile.d/

RUN yum -y install less &&\
    yum -y install iproute &&\
    yum -y install which &&\
    yum -y install openssh-server &&\
    yum -y install openssh-clients &&\
    yum -y install apache-commons-daemon-jsvc &&\
    yum -y install epel-release &&\
    yum -y install pdsh &&\
    yum -y install supervisor &&\
    yum clean all &&\
    mkdir -p /etc/supervisord.d &&\
    mkdir -p /usr/java/ &&\
    ln -sf -T /opt/java/lib/jdk1.8.0_112/ /usr/java/latest &&\
    mkdir -p /usr/hadoop/env &&\
    mkdir -p /usr/hadoop/conf &&\
    ln -sf -T /opt/hadoop/lib/hadoop-2.7.3/ /usr/hadoop/latest &&\
    ln -sf -T /usr/hadoop/conf/ /usr/hadoop/latest/conf &&\
    ln -sf -T /usr/hadoop/env/ /usr/hadoop/latest/env &&\
    echo "root" | passwd --stdin root &&\
    groupadd hadoop &&\
    groupadd hadoopadmin &&\
    groupadd hadoopuser &&\
    useradd -d /home/.hdfs -g hadoop hdfs &&\
    echo "hdfs" | passwd --stdin hdfs &&\
    useradd -d /home/.yarn -g hadoop yarn &&\
    echo "yarn" | passwd --stdin yarn &&\
    useradd -d /home/.mapred -g hadoop mapred &&\
    echo "mapred" | passwd --stdin mapred &&\
    useradd -g hadoopadmin admin &&\
    echo "admin" | passwd --stdin admin &&\
    useradd -g hadoopuser user &&\
    echo "user" | passwd --stdin user &&\
    mv /tmp/env/* /usr/hadoop/env && rmdir /tmp/env &&\
    mv /tmp/conf/* /usr/hadoop/conf && rmdir /tmp/conf  &&\
    mv /tmp/profile.d/* /etc/profile.d && rmdir /tmp/profile.d  &&\
    mkdir -p /var/run/hdfs &&\
    mkdir -p /var/log/hdfs &&\
    mkdir -p /var/run/yarn &&\
    mkdir -p /var/log/yarn &&\
    chown -R hdfs:hadoop /opt/hadoop &&\
    chown -R hdfs:hadoop /usr/hadoop &&\
    chown -R hdfs:hadoop /var/run/hdfs &&\
    chown -R hdfs:hadoop /var/log/hdfs &&\
    chown -R yarn:hadoop /var/run/yarn &&\
    chown -R yarn:hadoop /var/log/yarn
