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

COPY setup.hql /opt/hive/

# Put back the JAVA_HOME to point to previous version of java (version 8)
ENV JAVA_HOME=/usr/local/openjdk-8
ENV PATH=/usr/local/openjdk-8:/opt/apache-maven-3.9.9/bin:/opt/hive/bin:/opt/hadoop/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin/

# USER hive
