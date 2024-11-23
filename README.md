# spatial-analytics
Integration of Esri tools for hadoop

# Getting started
```
docker build . -t hive:gis
docker run -d -p 10000:10000 -p 10002:10002 --env SERVICE_NAME=hiveserver2 --name hive4 hive:gis
```
Connect to hive in interactive mode with beeline
```
 docker exec -it hive4 beeline -u 'jdbc:hive2://localhost:10000/'
```
Then exec the setup.hql script
```
beeline> !run setup.hql
```
The output should look like 
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