### Use a previously built image containing all the required libraries/software as base image
FROM hadoop_base:latest                                                                    #### Use hadoop_base:latest as base image

### Include custom configuration
ADD lib/supervisord/supervisord.conf /etc/supervisord.d                                    #### Supervisord configuration

### Generate ssh keys [these will be the same throughout the cluster. It is not optimal but at least
### we will be able to spawn any number of containers without having to do any manual configuration]
RUN ssh-keygen -A &&\                                                                      #### Generate the sshd keys for all key types [these will be placed in /etc/ssh/]
### Setup passwordless ssh for each user from within the cluster network
    mkdir -p /home/.yarn/.ssh &&\                                                          #### Generate rsa keys for the yarn user
    ssh-keygen -t rsa -P "" -f /home/.yarn/.ssh/id_rsa &&\                                 ####
    cat /home/.yarn/.ssh/id_rsa.pub >> /home/.yarn/.ssh/authorized_keys &&\                #### Add the rsa public key for the yarn user to the list of authorized keys [for yarn]
    chown -R yarn:hadoop /home/.yarn/.ssh &&\                                              #### chown and chmod appropriately
    chmod -R 0600 /home/.yarn/.ssh/* &&\                                                   #### 
    mkdir -p /home/.hdfs/.ssh &&\                                                          #### Generate rsa keys for the hdfs user
    ssh-keygen -t rsa -P "" -f /home/.hdfs/.ssh/id_rsa &&\                                 ####
    cat /home/.hdfs/.ssh/id_rsa.pub >> /home/.hdfs/.ssh/authorized_keys &&\                #### Add the rsa public key for the hdfs user to the list of authorized keys [for hdfs]
    chown -R hdfs:hadoop /home/.hdfs/.ssh &&\                                              #### chown and chmod appropriately
    chmod -R 0600 /home/.hdfs/.ssh/* &&\                                                   ####
    mkdir -p /home/.mapred/.ssh &&\                                                        #### Generate rsa keys for the mapred user
    ssh-keygen -t rsa -P "" -f /home/.mapred/.ssh/id_rsa &&\                               ####
    cat /home/.mapred/.ssh/id_rsa.pub >> /home/.mapred/.ssh/authorized_keys &&\            #### Add the rsa public key for the mapred user to the list of authorized keys [for mapred]
    chown -R mapred:hadoop /home/.mapred/.ssh &&\                                          #### chown and chmod appropriately
    chmod -R 0600 /home/.mapred/.ssh/* &&\                                                 ####
    mkdir -p /home/admin/.ssh &&\                                                          #### Generate rsa keys for the admin user
    ssh-keygen -t rsa -P "" -f /home/admin/.ssh/id_rsa &&\                                 ####
    cat /home/admin/.ssh/id_rsa.pub >> /home/admin/.ssh/authorized_keys &&\                #### Add the rsa public key for the admin user to the list of authorized keys [for admin]
    chown -R admin:hadoopadmin /home/admin/.ssh &&\                                        #### chown and chmod appropriately
    chmod -R 0600 /home/admin/.ssh/* &&\                                                   ####
    mkdir -p /home/user/.ssh &&\                                                           #### Generate rsa keys for the user user
    ssh-keygen -t rsa -P "" -f /home/user/.ssh/id_rsa &&\                                  ####
    cat /home/user/.ssh/id_rsa.pub >> /home/user/.ssh/authorized_keys &&\                  #### Add the rsa public key for the user user to the list of authorized keys [for user]
    chown -R user:hadoopuser /home/user/.ssh &&\                                           #### chown and chmod appropriately
    chmod -R 0600 /home/user/.ssh/* &&\                                                    ####
    
    
    cat /etc/ssh/ssh_host_ecdsa_key.pub |\                                                 #### Allow connecting to localhost and "local" addresses using the sshd public ecdsa key
                                                                                           #### If needed change this behaviour to include also the sshd rsa and ed25519 public keys
    awk '{ print "::,0.0.0.0,127.*.*.*,localhost,172.18.*.*,dn*,mn* "$1" "$2 }' > /etc/ssh/ssh_known_hosts &&\
    chmod 644 /etc/ssh/ssh_known_hosts                                                     #### Chown and chmod appropriately

ENTRYPOINT /usr/bin/supervisord -n -c /etc/supervisord.d/supervisord.conf                  #### Entrypoint for all the containers: run supervisord in non daemon mode
