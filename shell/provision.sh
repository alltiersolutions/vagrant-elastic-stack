#!/bin/bash

NOW=`date +%Y-%m-%d-%H%M`

JAVA="/usr/bin/java"

JAVA_RPM="/vagrant/downloads/jdk-8u121-linux-x64.rpm"
JAVA_RPM_SHA1="bc94fc0d0c7dec448e55a222749258c0145ca914"
ELASTICSEARCH_RPM="/vagrant/downloads/elasticsearch-5.2.0.rpm"
ELASTICSEARCH_RPM_SHA1="11b669aa17cc77cf1431a646e0d1e5d8ed5f26be"
KIBANA_RPM="/vagrant/downloads/kibana-5.2.0-x86_64.rpm"
KIBANA_RPM_SHA1="0aa1a266ee96522c773ecfefc0417c97ddde2717"
LOGSTASH_RPM="/vagrant/downloads/logstash-5.2.0.rpm"
LOGSTASH_RPM_SHA1="768ef74dfcc362f3230ab28221515f3917c46a73"
FILEBEAT_RPM="/vagrant/downloads/filebeat-5.2.0-x86_64.rpm"
FILEBEAT_RPM_SHA1="e2011711763e184d5530470243617064714c8207"

#################################################################
# install_java
# Checks to see if Java is installed.
#################################################################
install_java() {
  if [ -x $JAVA ]; then
    echo "Java is already installed..."
    $JAVA -version
  else
    echo "Installing Java..."
    # Check to see if the Java RPM has previously been downloaded.
    if [ -x $JAVA_RPM ]; then
      echo "${JAVA_RPM} already exists! Skipping download..."
    else
      echo "Downloading Java RPM to ${JAVA_RPM}..."
      /usr/bin/wget --quiet -O $JAVA_RPM --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm"
    fi
    # Install Java
    check_sha1 $JAVA_RPM $JAVA_RPM_SHA1
    /usr/bin/rpm --install $JAVA_RPM > /dev/null 2>&1
    $JAVA -version
  fi
}

#################################################################
# install_elasticsearch
# Checks to see if Elasticsearch is installed.
#################################################################
install_elasticsearch() {
  if [ "$(rpm -qa elasticsearch)" ]; then
    echo "Elasticsearch is already installed..."
  else
    echo "Installing Elasticsearch..."
    # Check to see if the Elasticsearch RPM has previously been downloaded.
    if [ -x $ELASTICSEARCH_RPM ]; then
      echo "${ELASTICSEARCH_RPM} already exists! Skipping download..."
    else
      echo "Downloading Elasticsearch RPM to ${ELASTICSEARCH_RPM}..."
      /usr/bin/wget --quiet -O $ELASTICSEARCH_RPM https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.2.0.rpm
    fi
    # Install Elasticsearch 
    check_sha1 $ELASTICSEARCH_RPM $ELASTICSEARCH_RPM_SHA1
    /usr/bin/rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    /usr/bin/rpm --install $ELASTICSEARCH_RPM > /dev/null 2>&1
    /usr/bin/cp -p /etc/elasticsearch/elasticsearch.yml{,.$NOW}
    /usr/bin/cp /vagrant/configs/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
    /bin/systemctl daemon-reload
    /bin/systemctl enable elasticsearch.service > /dev/null 2>&1
    /bin/systemctl start elasticsearch.service
  fi
}

#################################################################
# install_kibana
# Checks to see if Kibana is installed.
#################################################################
install_kibana() {
  if [ "$(rpm -qa kibana)" ]; then
    echo "Kibana is already installed..."
  else
    echo "Installing Kibana..."
    # Check to see if the Kibana RPM has previously been downloaded.
    if [ -x $KIBANA_RPM ]; then
      echo "${KIBANA_RPM} already exists! Skipping download..."
    else
      echo "Downloading Kibana RPM to ${KIBANA_RPM}..."
      /usr/bin/wget --quiet -O $KIBANA_RPM https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-x86_64.rpm
    fi
    # Install Kibana
    check_sha1 $KIBANA_RPM $KIBANA_RPM_SHA1
    /usr/bin/rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    /usr/bin/rpm --install $KIBANA_RPM > /dev/null 2>&1
    /usr/bin/cp -p /etc/kibana/kibana.yml{,.$NOW}
    /usr/bin/cp /vagrant/configs/kibana.yml /etc/kibana/kibana.yml
    /bin/systemctl daemon-reload
    /bin/systemctl enable kibana.service > /dev/null 2>&1
    /bin/systemctl start kibana.service
  fi
}

#################################################################
# install_logstash
# Checks to see if Logstash is installed.
#################################################################
install_logstash() {
  if [ "$(rpm -qa logstash)" ]; then
    echo "Logstash is already installed..."
  else
    echo "Installing Logstash..."
    # Check to see if the Logstash RPM has previously been downloaded.
    if [ -x $LOGSTASH_RPM ]; then
      echo "${LOGSTASH_RPM} already exists! Skipping download..."
    else
      echo "Downloading Logstash RPM to ${LOGSTASH_RPM}..."
      /usr/bin/wget --quiet -O $LOGSTASH_RPM https://artifacts.elastic.co/downloads/logstash/logstash-5.2.0.rpm
    fi
    # Install Logstash
    check_sha1 $LOGSTASH_RPM $LOGSTASH_RPM_SHA1
    /usr/bin/rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    /usr/bin/rpm --install $LOGSTASH_RPM > /dev/null 2>&1
    /usr/bin/cp /vagrant/configs/logstash/conf.d/first-pipeline.conf /etc/logstash/conf.d/
    /bin/systemctl daemon-reload
    /bin/systemctl enable logstash.service > /dev/null 2>&1
    /bin/systemctl start logstash.service
  fi
}

#################################################################
# install_filebeat
# Checks to see if Filebeat is installed.
#################################################################
install_filebeat() {
  if [ "$(rpm -qa filebeat)" ]; then
    echo "Filebeat is already installed..."
  else
    echo "Installing Filebeat..."
    # Check to see if the Filebeat RPM has previously been downloaded.
    if [ -x $FILEBEAT_RPM ]; then
      echo "${FILEBEAT_RPM} exists!"
    else
      echo "Downloading Filebeat RPM to ${FILEBEAT_RPM}..."
      /usr/bin/wget --quiet -O $FILEBEAT_RPM https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.0-x86_64.rpm
    fi
    # Install Filebeat
    check_sha1 $FILEBEAT_RPM $FILEBEAT_RPM_SHA1
    /usr/bin/rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    /usr/bin/rpm --install $FILEBEAT_RPM > /dev/null 2>&1
    /usr/bin/cp -p /etc/filebeat/filebeat.yml{,.$NOW}
    /usr/bin/cp /vagrant/configs/filebeat.yml /etc/filebeat/filebeat.yml
    /bin/systemctl daemon-reload
    /bin/systemctl enable filebeat.service > /dev/null 2>&1
    /bin/systemctl start filebeat.service
  fi
}

#################################################################
# check_sha1 
# Compute and check SHA1 message digest.
#################################################################
check_sha1() {

  echo "Verifying ${1} file integrity..."

  SHA1=`sha1sum $1 | awk '{print $1}'`
  if [ $SHA1 == $2 ]; then
    echo "${1}: OK"
  else
    echo "SHA1 mismatch on ${1}!!! Exiting..."
    exit 1
  fi

}

install_java
install_elasticsearch
install_kibana
install_logstash
install_filebeat

echo "Environment provisioned. Open a web browser and navigate to http://localhost:5601"
