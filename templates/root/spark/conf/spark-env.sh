#!/usr/bin/env bash

export SPARK_LOCAL_DIRS="{{spark_local_dirs}}"

# Standalone cluster options
export SPARK_MASTER_OPTS="{{spark_master_opts}}"
if [ -n "{{spark_worker_instances}}" ]; then
  export SPARK_WORKER_INSTANCES={{spark_worker_instances}}
fi
export SPARK_WORKER_CORES={{spark_worker_cores}}

export HADOOP_HOME="/root/ephemeral-hdfs"
export SPARK_MASTER_IP={{active_master}}
export MASTER=`cat /root/spark-ec2/cluster-url`

export SPARK_SUBMIT_LIBRARY_PATH="$SPARK_SUBMIT_LIBRARY_PATH:/root/ephemeral-hdfs/lib/native/"
export SPARK_SUBMIT_CLASSPATH="$SPARK_CLASSPATH:$SPARK_SUBMIT_CLASSPATH:/root/ephemeral-hdfs/conf"

# Bind Spark's web UIs to this machine's public EC2 hostname otherwise fallback to private IP:
export SPARK_PUBLIC_DNS=`
wget -q -O - http://169.254.169.254/latest/meta-data/public-hostname ||\
wget -q -O - http://169.254.169.254/latest/meta-data/local-ipv4`

# Used for YARN model
export YARN_CONF_DIR="/root/ephemeral-hdfs/conf"

# Set a high ulimit for large shuffles, only root can do this
if [ $(id -u) == "0" ]
then
    ulimit -n 1000000
fi

# Custom
SPARK_LOG_DIR=/var/log/spark
SPARK_WORKER_CORES=16
SPARK_WORKER_DIR=/tmp/spark-worker
SPARK_CLASSPATH="$SPARK_HOME/lib/hadoop-aws-2.6.0.jar:$SPARK_HOME/lib/aws-java-sdk-core-1.10.49.jar:$SPARK_HOME/lib/aws-java-sdk-s3-1.10.49.jar:$SPARK_HOME/lib/guava-15.0.jar:$SPARK_HOME/lib/spark-csv_2.11-1.3.0.jar:$SPARK_HOME/lib/univocity-parsers-1.5.1.jar:$SPARK_HOME/lib/commons-csv-1.1.jar"
