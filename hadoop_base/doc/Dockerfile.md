### Define the base image for the containers
FROM centos:centos7                                                                       #### Use centos7 as base image

### Add all the required custom libraries (not managed by a software manager [yum]) 
ADD lib/java/oracle/jdk8/jdk-8u112-linux-x64.tar.gz /opt/java/lib/                        #### Add the required java library
ADD lib/hadoop/hadoop-2.7.3/hadoop-2.7.3.tar.gz /opt/hadoop/lib/                          #### Add the required hadoop library

### Copy to all the required custom  scripts and config files into the image
COPY lib/hadoop/env/* /tmp/env                                                            #### Add hadoop environment scripts
COPY lib/hadoop/conf/* /tmp/conf                                                          #### Add hadoop environment configs
COPY lib/profile.d/* /tmp/profile.d                                                       #### Add profile.d scripts

### Install all the required sofware
RUN yum -y install less &&\                                                               #### Utils: less        - debug and administration
    yum -y install iproute &&\                                                            #### Utils: iproute     - debug and administration
    yum -y install which &&\                                                              #### Utils: which       - required by hadoop scripts
    yum -y install openssh-server &&\                                                     #### Utils: ssh         - required by hadoop scripts
    yum -y install openssh-clients &&\                                                    #### Utils: ssh         - required by hadoop scripts
    yum -y install apache-commons-daemon-jsvc &&\                                         #### Utils: jsvc        - required to run secure hadoop
    yum -y install epel-release &&\                                                       #### Repository containing pdsh and supervisor
    yum -y install pdsh &&\                                                               #### Utils: pdsh        - enhanced ssh management
    yum -y install supervisor &&\                                                         #### Utils: supervisor  - container initialization management
    yum clean all &&\                                                                     #### Clean yum cache in this layer
### Symlinks for maintainability
    mkdir -p /etc/supervisord.d &&\                                                       #### Directory for the supervisord.conf file
    mkdir -p /usr/java/ &&\                                                               #### Symlink the java home directory in use to /usr/java/latest
    ln -sf -T /opt/java/lib/jdk1.8.0_112/ /usr/java/latest &&\                            ####
    mkdir -p /usr/hadoop/env &&\                                                          ####
    mkdir -p /usr/hadoop/conf &&\                                                         #### 
    ln -sf -T /opt/hadoop/lib/hadoop-2.7.3/ /usr/hadoop/latest &&\                        #### Symlink the hadoop prefix directory in use to /usr/hadoop/latest
    ln -sf -T /usr/hadoop/conf/ /usr/hadoop/latest/conf &&\                               #### Symlink the /usr/hadoop/conf to /usr/hadoop/latest/conf for site specific configurations
    ln -sf -T /usr/hadoop/env/ /usr/hadoop/latest/env &&\                                 #### Symlink the /usr/hadoop/env to /usr/hadoop/latest/env for site specific configurations
### Add required groups, users and passwords
    echo "root" | passwd --stdin root &&\                                                 #### Set the password possword for the root user
    groupadd hadoop &&\                                                                   #### Hadoop group for technical users (ex: yarn)
    groupadd hadoopadmin &&\                                                              #### Hadoop admin group
    groupadd hadoopuser &&\                                                               #### Hadoop user group
    useradd -d /home/.hdfs -g hadoop hdfs &&\                                             #### Hdfs user without home dir
    echo "hdfs" | passwd --stdin hdfs &&\                                                 ####
    useradd d /home/.yarn -g hadoop yarn &&\                                              #### Yarn user with home dir - most hadoop processes will run as this user
    echo "yarn" | passwd --stdin yarn &&\                                                 ####
    useradd -d /home/.mapred -g hadoop mapred &&\                                         #### Mapred user
    echo "mapred" | passwd --stdin mapred &&\                                             ####
    useradd -g hadoopadmin admin &&\                                                      #### Admin user
    echo "admin" | passwd --stdin admin &&\                                               ####
    useradd -g hadoopuser user &&\                                                        #### Normal user
    echo "user" | passwd --stdin user &&\                                                 ####
### Move configuration files and env scripts to the appropriate paths and remove tmp dirs
    mv /tmp/env/* /usr/hadoop/env && rmdir /tmp/env &&\                                   ####
    mv /tmp/conf/* /usr/hadoop/conf && rmdir /tmp/conf  &&\                               ####
    mv /tmp/profile.d/* /etc/profile.d && rmdir /tmp/profile.d  &&\                       ####
### Create the log and run directories for the hadoop processes
    mkdir -p /var/run/hdfs &&\                                                            #### Hdfs run directory
    mkdir -p /var/log/hdfs &&\                                                            #### Hdfs log directory
    mkdir -p /var/run/yarn &&\                                                            #### Yarn run directory
    mkdir -p /var/log/yarn &&\                                                            #### Yarn log directory
### Chown hadoop directories as appropriate
    chown -R hdfs:hadoop /opt/hadoop &&\                                                  ####
    chown -R hdfs:hadoop /usr/hadoop &&\                                                  ####
    chown -R hdfs:hadoop /var/run/hdfs &&\                                                ####
    chown -R hdfs:hadoop /var/log/hdfs &&\                                                ####
    chown -R yarn:hadoop /var/run/yarn &&\                                                ####
    chown -R yarn:hadoop /var/log/yarn                                                    ####
