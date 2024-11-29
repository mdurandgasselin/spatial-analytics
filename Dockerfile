FROM apache/hive:4.0.0


USER root
RUN apt update && apt upgrade -y
RUN apt install git -y
RUN apt install wget -y

# Download apache Maven to use it for the spatial-framework-for-hadoop
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz && \
    tar -xzvf apache-maven-3.9.9-bin.tar.gz && \
    mv apache-maven-3.9.9 /opt/ && \
    rm apache-maven-3.9.9-bin.tar.gz
# Update PATH environment variable
ENV PATH=/opt/apache-maven-3.9.9/bin:$PATH

RUN git clone https://github.com/Esri/gis-tools-for-hadoop.git

WORKDIR /opt/hive
RUN git clone https://github.com/Esri/spatial-framework-for-hadoop.git
WORKDIR /opt/hive/spatial-framework-for-hadoop

# Install java 11 for the spatial-framework-for-hadoop
RUN apt install openjdk-11-jdk -y
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# REMOVE JAVA 8 and put back java 11
ENV PATH=/usr/lib/jvm/java-11-openjdk-amd64:/opt/apache-maven-3.9.9/bin:/opt/hive/bin:/opt/hadoop/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin/
# Run the Maven install
RUN mvn install
# Copy output jar file to the hive/lib so it can be accesed in the beeline cli
RUN cp hive/target/spatial-sdk-hive-2.2.1-SNAPSHOT*.jar $HIVE_HOME/lib/
RUN cp json/target/spatial-sdk-json-2.2.1-SNAPSHOT*.jar $HIVE_HOME/lib/
# Add and example script to show case the setup
COPY setup.hql /opt/hive/

# Put back the JAVA_HOME to point to previous version of java (version 8)
#ENV JAVA_HOME=/usr/local/openjdk-8
#ENV PATH=/usr/local/openjdk-8:/opt/apache-maven-3.9.9/bin:/opt/hive/bin:/opt/hadoop/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin/

WORKDIR /opt
RUN wget https://dlcdn.apache.org/zeppelin/zeppelin-0.11.2/zeppelin-0.11.2-bin-all.tgz && \
    tar zxvf zeppelin-0.11.2-bin-all.tgz && \
    rm zeppelin-0.11.2-bin-all.tgz

RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-service/4.0.0/hive-service-4.0.0.jar
RUN mv hive-service-4.0.0.jar zeppelin-0.11.2-bin-all/lib/
RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-common/4.0.0/hive-common-4.0.0.jar
RUN mv  hive-common-4.0.0.jar zeppelin-0.11.2-bin-all/lib/
RUN wget https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.16.0/libthrift-0.16.0.jar
RUN mv libthrift-0.16.0.jar zeppelin-0.11.2-bin-all/lib/

RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-jdbc/4.0.0/hive-jdbc-4.0.0.jar
RUN mv hive-jdbc-4.0.0.jar zeppelin-0.11.2-bin-all/lib/

COPY jdbc/interpreter-setting.json /opt/zeppelin-0.11.2-bin-all/interpreter/jdbc/
COPY conf/interpreter.json /opt/zeppelin-0.11.2-bin-all/conf/

ENV ZEPPELIN_ADDR=0.0.0.0

# RUN bin/zeppelin-daemon.sh start

WORKDIR /opt/hive

#USER hive
