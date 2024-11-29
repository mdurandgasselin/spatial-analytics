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

CREATE TABLE message1 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 1.",
    receiver_timestamp int COMMENT "Metadata: timestamp when the message was received",
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string COMMENT "Unique number to identify the ship.",
    status int COMMENT "Navigational status: 0 = using engine, 1 = at anchor, 2 = not under command, 3 = restricted maneuverability, 4 = constrained draught, 5 = moored, 6 = aground, 7 = fishing, 8 = under way sailing",
    turn int COMMENT "Rate of turn. positive = turn right, negative = turn left. -128 = default no information available", 
    speed double COMMENT "Speed over ground SOG in Knots", 
    accuracy int Comment "position accuracy: 1 = high (<= 10 m), 0 = low (> 10 m), 0 = default", 
    lon float Comment "Longitude in 1/10 000 min, (+/-180 deg, East = positive (as per 2's complement), West = negative", 
    lat float Comment "Latitude in 1/10 000 min (+/-90 deg, North = positive, South = negative", 
    course float Comment "Course over ground", 
    heading int Comment "Degrees (0-359) (511 indicates not available)", 
    second int Comment "UTC second when the report was generated by the electronic position system (EPFS) (0-59, or 60 if time stamp is not available)", 
    maneuver int COMMENT "0 = not available = default, 1 = not engaged in special maneuver, 2 = engaged in special maneuver", 
    spare_1 string COMMENT "Not used. Should be set to zero. Reserved for future use.", 
    raim int COMMENT "Receiver autonomous integrity monitoring (RAIM) flag of electronic position fixing device; 0 = RAIM not in use = default; 1 = RAIM in use. See Table", 
    radio string COMMENT "0 UTC direct (sync from own integral GPS receiver), 1 UTC indirect (own GPS unavailable - UTC sync from GPS, receiver on nearby ship or base station), 2 Station is synchronized to a base station (base direct - GPS unavailable), 3 Station is synchronized to another station"
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE message3 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 3.",
    receiver_timestamp int COMMENT "Metadata: timestamp when the message was received",
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string COMMENT "Unique number to identify the ship.",
    status int COMMENT "Navigational status: 0 = using engine, 1 = at anchor, 2 = not under command, 3 = restricted maneuverability, 4 = constrained draught, 5 = moored, 6 = aground, 7 = fishing, 8 = under way sailing",
    turn int COMMENT "Rate of turn. positive = turn right, negative = turn left. -128 = default no information available", 
    speed double COMMENT "Speed over ground SOG in Knots", 
    accuracy int Comment "position accuracy: 1 = high (<= 10 m), 0 = low (> 10 m), 0 = default", 
    lon float Comment "Longitude in 1/10 000 min, (+/-180 deg, East = positive (as per 2's complement), West = negative", 
    lat float Comment "Latitude in 1/10 000 min (+/-90 deg, North = positive, South = negative", 
    course float Comment "Course over ground", 
    heading int Comment "Degrees (0-359) (511 indicates not available)", 
    second int Comment "UTC second when the report was generated by the electronic position system (EPFS) (0-59, or 60 if time stamp is not available)", 
    maneuver int COMMENT "0 = not available = default, 1 = not engaged in special maneuver, 2 = engaged in special maneuver", 
    spare_1 string COMMENT "Not used. Should be set to zero. Reserved for future use.", 
    raim int COMMENT "Receiver autonomous integrity monitoring (RAIM) flag of electronic position fixing device; 0 = RAIM not in use = default; 1 = RAIM in use. See Table", 
    radio string COMMENT "0 UTC direct (sync from own integral GPS receiver), 1 UTC indirect (own GPS unavailable - UTC sync from GPS, receiver on nearby ship or base station), 2 Station is synchronized to a base station (base direct - GPS unavailable), 3 Station is synchronized to another station"
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE message5 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 5.",
    receiver_timestamp int COMMENT "Metadata: timestamp when the message was received",
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string COMMENT "Unique number to identify the ship.",
    ais_version int COMMENT "0 = station compliant with AIS edition 0; 1-3 = station compliant with future AIS editions 1, 2, and 3",
    imo string COMMENT "1-999999999; 0 = not available = default", 
    callsign string COMMENT "7 ´ 6 bit ASCII characters, @@@@@@@ = not available = default", 
    shipname string COMMENT "Maximum 20 characters 6 bit ASCII, @@@@@@@@@@@@@@@@@@@@ = not available = default", 
    ship_type int COMMENT "0 = not available or no ship = default. 1-99 = other see at https://emsa.europa.eu/cise-documentation/cise-data-model-1.5.3/model/guidelines/AIS-Message-5_687507198.html ", 
    to_bow int COMMENT "See figure at https://emsa.europa.eu/cise-documentation/cise-data-model-1.5.3/model/guidelines/AIS-Message-5_687507198.html", 
    to_stern int COMMENT "See figure at https://emsa.europa.eu/cise-documentation/cise-data-model-1.5.3/model/guidelines/AIS-Message-5_687507198.html", 
    to_port int COMMENT "See figure at https://emsa.europa.eu/cise-documentation/cise-data-model-1.5.3/model/guidelines/AIS-Message-5_687507198.html",  
    to_starboard int COMMENT "See figure at https://emsa.europa.eu/cise-documentation/cise-data-model-1.5.3/model/guidelines/AIS-Message-5_687507198.html", 
    epfd  int COMMENT "0 = undefined (default). 1 = GPS. 2 = GLONASS. 3 = combined GPS/GLONASS. 4 = Loran-C. 5 = Chayka, 6 = integrated navigation system, 7 = surveyed, 8-15 = not used", 
    month int COMMENT "Estimated time of arrival Month", 
    day int COMMENT "Estimated time of arrival Day", 
    hour int COMMENT "Estimated time of arrival Hour", 
    minute int COMMENT "Estimated time of arrival Minute", 
    draught float COMMENT "in 1/10 m, 255 = draught 25.5 m or greater, 0 = not available = default; in accordance with IMO Resolution A.851", 
    destination string COMMENT "Maximum 20 characters using 6-bit ASCII; @@@@@@@@@@@@@@@@@@@@ = not available", 
    dte int COMMENT "Data terminal ready (0 = available, 1 = not available = default)", 
    spare_1 string COMMENT "Not used. Should be set to zero. Reserved for future use.", 
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE message18 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here always 18.",
    receiver_timestamp int COMMENT "Metadata: timestamp when the message was received",
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string COMMENT "Unique number to identify the ship.",
    reserved_1 int COMMENT "Not used. Should be set to zero. Reserved for future use",  
    speed double COMMENT "Speed over ground SOG in Knots", 
    accuracy int Comment "position accuracy: 1 = high (<= 10 m), 0 = low (> 10 m), 0 = default",
    lon float COMMENT "Longitude in 1/10 000 min, (+/-180 deg, East = positive (as per 2's complement), West = negative", 
    lat float COMMENT "Latitude in 1/10 000 min (+/-90 deg, North = positive, South = negative", 
    course float COMMENT "Course over ground in 1/10= (0-3 599). 3 600 (E10h) = not available = default", 
    heading int COMMENT "Degrees (0-359) (511 indicates not available)", 
    second int COMMENT "UTC second when the report was generated by the electronic position system (EPFS) (0-59, or 60 if time stamp is not available)", 
    reserved_2 int COMMENT "Not used. Should be set to zero. Reserved for future use",
    cs int COMMENT "0 = Class B SOTDMA unit, 1 = Class B 'CS' unit", 
    display int COMMENT "0 = No display available; not capable of displaying Message 12 and 14. 1 = Equipped with integrated display displaying Message 12 and 14",
    dsc int COMMENT "0 = Not equipped with DSC function. 1 = Equipped with DSC function (dedicated or time-shared)", 
    band int COMMENT "0 = Capable of operating over the upper 525 kHz band of the marine band. 1 = Capable of operating over the whole marine band, (irrelevant if 'Class B Message 22 flag' is 0)", 
    msg22 int COMMENT "0 = No frequency management via Message 22 , operating on AIS1, AIS2 only. 1 = Frequency management via Message 22", 
    assigned int COMMENT "0 = Station operating in autonomous and continuous mode = default. 1 = Station operating in assigned mode",
    raim int COMMENT "Receiver autonomous integrity monitoring (RAIM) flag of electronic position fixing device; 0 = RAIM not in use = default; 1 = RAIM in use. See Table", 
    radio string COMMENT "0 UTC direct (sync from own integral GPS receiver). 1 UTC indirect (own GPS unavailable - UTC sync from GPS, receiver on nearby ship or base station), 2 Station is synchronized to a base station (base direct - GPS unavailable), 3 Station is synchronized to another station"
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE message19 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 19.",
    receiver_timestamp int,
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string,
    reserved_1 int,
    speed double, 
    accuracy int, 
    lon float, 
    lat float,
    course float,
    second int, 
    reserved_2 int,
    callsign string, 
    shipname string, 
    ship_type int, 
    to_bow int, 
    to_stern int, 
    to_port int, 
    to_starboard int, 
    epfd  int, 
    dte int, 
    assigned int,
    spare_1 string
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;


CREATE TABLE message21 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 21.",
    receiver_timestamp int,
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string,
    aid_type int, 
    name string,
    accuracy int, 
    lon float, 
    lat float,
    to_bow int, 
    to_stern int, 
    to_port int, 
    to_starboard int, 
    epfd  int, 
    second int,
    off_position int,  
    reserved_1 int,
    raim int,
    virtual_aid int,
    assigned int,
    spare_1 string,
    name_ext string
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE message24 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 24.",
    receiver_timestamp int,
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string,
    partno int,
    shipname string,
    spare_1 string,
    to_starboard int, 
    callsign string,
    serial string,
    ship_type int,
    model int,
    vendorid string,
    to_port int, 
    to_bow int, 
    to_stern int 
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

CREATE TABLE message8 (
    msg_type int COMMENT "Type for message range from 1 to 27. Here alway 8.",
    receiver_timestamp int,
    repeated int COMMENT "Alias to 'repeat'. how many times a message has been repeated (0-3). The number of stations received the message.",
    mmsi string,
    spare_1 string,
    dac int,
    fid int,
    data binary    
    )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE;