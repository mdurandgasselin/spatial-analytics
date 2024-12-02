# spatial-analytics
This is a training application to show case the integration of Apache Zeppelin with Apache Hive. The Hive warehouse is in standalone mode.
The Hive docker image also add the Esri tools for hadoop. This allows to use spatial functions and data representation in a Hive Warehouse.

# Getting started
To start the whole application:
```
docker-compose up -d
```
Connect to hive in interactive mode with beeline
```
 docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
```
Then exec the setup.hql script which add a few tables to work with.
```
beeline> !run setup.hql
```
It also run a simple test from ESRI Gis tool for Hadoop samples database. The output should look like:
```
Kern  36
San Bernardino	35
Imperial	28
Inyo	20
Los Angeles	18
Riverside	14
Monterey	14
Santa Clara	12
Fresno	11
San Benito	11
San Diego	7
Santa Cruz	5
San Luis Obispo	3
Ventura	3
Orange	2
San Mateo	1
```
And two tables will be created "earthquakes" and "counties"

The Zeppelin notebook server is available at http://localhost:8080. Start a notebook using the jdbc interpreter. It was configured to connect to the hive. 

To start the Hive server independantly use in the hivedb folder:
```
docker build . -t hive:gis
```
And to run 
```
docker run -d -p 10000:10000 -p 10002:10002 -v %CD%:/opt/data --env SERVICE_NAME=hiveserver2 --name hive4 hive:gis
```
Connect to hive in interactive mode with beeline
```
 docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
```
In the app folder there are .py files and iPython notebooks that are configured to connect to the Hive server/container.
