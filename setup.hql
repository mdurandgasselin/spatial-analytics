add jar 
   /opt/hive/gis-tools-for-hadoop/samples/lib/esri-geometry-api-2.0.0.jar
   /opt/hive/gis-tools-for-hadoop/samples/lib/spatial-sdk-hive-2.0.0.jar
   /opt/hive/gis-tools-for-hadoop/samples/lib/spatial-sdk-json-2.0.0.jar;

create temporary function ST_Point as 'com.esri.hadoop.hive.ST_Point';
create temporary function ST_Contains as 'com.esri.hadoop.hive.ST_Contains';

drop table earthquakes;
drop table counties;

CREATE TABLE earthquakes (earthquake_date STRING, latitude DOUBLE, longitude      DOUBLE, depth DOUBLE, magnitude DOUBLE,
    magtype string, mbstations string, gap string, distance string, rms string, source string, eventid string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE counties (Area string, Perimeter string, State string, County string, Name string, BoundaryShape binary)                  
ROW FORMAT SERDE 'com.esri.hadoop.hive.serde.EsriJsonSerDe'
STORED AS INPUTFORMAT 'com.esri.json.hadoop.EnclosedEsriJsonInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';

LOAD DATA INPATH '/opt/hive/gis-tools-for-hadoop/samples/data/earthquake-data/earthquakes.csv' OVERWRITE INTO TABLE earthquakes;
LOAD DATA INPATH '/opt/hive/gis-tools-for-hadoop/samples/data/counties-data/california-counties.json' OVERWRITE INTO TABLE counties;

SELECT counties.name, count(*) cnt FROM counties
JOIN earthquakes
WHERE ST_Contains(counties.boundaryshape, ST_Point(earthquakes.longitude, earthquakes.latitude))
GROUP BY counties.name
ORDER BY cnt desc;