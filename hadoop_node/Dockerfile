FROM hadoop_base:latest

ADD lib/supervisord/supervisord.conf /etc/supervisord.d

RUN ssh-keygen -A &&\
    mkdir -p /home/.yarn/.ssh &&\
    ssh-keygen -t rsa -P "" -f /home/.yarn/.ssh/id_rsa &&\
    cat /home/.yarn/.ssh/id_rsa.pub >> /home/.yarn/.ssh/authorized_keys &&\
    chown -R yarn:hadoop /home/.yarn/.ssh &&\
    chmod -R 0600 /home/.yarn/.ssh/* &&\
    mkdir -p /home/.hdfs/.ssh &&\
    ssh-keygen -t rsa -P "" -f /home/.hdfs/.ssh/id_rsa &&\
    cat /home/.hdfs/.ssh/id_rsa.pub >> /home/.hdfs/.ssh/authorized_keys &&\
    chown -R hdfs:hadoop /home/.hdfs/.ssh &&\
    chmod -R 0600 /home/.hdfs/.ssh/* &&\
    mkdir -p /home/.mapred/.ssh &&\
    ssh-keygen -t rsa -P "" -f /home/.mapred/.ssh/id_rsa &&\
    cat /home/.mapred/.ssh/id_rsa.pub >> /home/.mapred/.ssh/authorized_keys &&\
    chown -R mapred:hadoop /home/.mapred/.ssh &&\
    chmod -R 0600 /home/.mapred/.ssh/* &&\
    mkdir -p /home/admin/.ssh &&\
    ssh-keygen -t rsa -P "" -f /home/admin/.ssh/id_rsa &&\
    cat /home/admin/.ssh/id_rsa.pub >> /home/admin/.ssh/authorized_keys &&\
    chown -R admin:hadoopadmin /home/admin/.ssh &&\
    chmod -R 0600 /home/admin/.ssh/* &&\
    mkdir -p /home/user/.ssh &&\
    ssh-keygen -t rsa -P "" -f /home/user/.ssh/id_rsa &&\
    cat /home/user/.ssh/id_rsa.pub >> /home/user/.ssh/authorized_keys &&\
    chown -R user:hadoopuser /home/user/.ssh &&\
    chmod -R 0600 /home/user/.ssh/* &&\
    cat /etc/ssh/ssh_host_ecdsa_key.pub | awk '{ print "::,0.0.0.0,127.*.*.*,localhost,172.18.*.*,dn*,mn* "$1" "$2 }' > /etc/ssh/ssh_known_hosts &&\
    chmod 644 /etc/ssh/ssh_known_hosts

ENTRYPOINT /usr/bin/supervisord -n -c /etc/supervisord.d/supervisord.conf
