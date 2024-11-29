FROM apache/zeppelin:0.11.2

USER root
RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-service/4.0.0/hive-service-4.0.0.jar  && \
    mv hive-service-4.0.0.jar lib/
RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-common/4.0.0/hive-common-4.0.0.jar  && \
    mv  hive-common-4.0.0.jar lib/
RUN wget https://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.16.0/libthrift-0.16.0.jar  && \
    mv libthrift-0.16.0.jar lib/

RUN wget https://repo1.maven.org/maven2/org/apache/hive/hive-jdbc/4.0.0/hive-jdbc-4.0.0.jar  && \
    mv hive-jdbc-4.0.0.jar lib/

COPY jdbc/interpreter-setting.json interpreter/jdbc/  
COPY conf/interpreter.json conf/

ENV ZEPPELIN_ADDR=0.0.0.0
EXPOSE 8080