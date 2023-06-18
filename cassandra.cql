/*
Rendu cassandra de :
    -Léo Paul FALQ
    -Ivan-Corneille MAGAGI
    -Tristan MAS
    -Victor ROBALO

Pour lancer ce script, il faut dans le l'ordre:
1. Installer cassandra et ses dépendances. 
2. Déposer ce script dans un répertoire.
3. A partir de la console de commandes, se positionner dans ce répertoire avec la commande "cd"
4. Executer la commande "cqlsh"
5. Executer la commande "source 'nom_dufichier.cql'"
*/

/* Création de l'espace de noms "WeatherStation" si elle n'existe pas déjà */
CREATE KEYSPACE IF NOT EXISTS WeatherStation
    WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };

/* Utilisation de l'espace de noms "WeatherStation" pour les opérations suivantes */
USE WeatherStation;

/* Création de la table "WeatherData" si elle n'existe pas déjà. Cette table stockera les données de la station météo. */
CREATE TABLE IF NOT EXISTS WeatherData (
    /* Définition des colonnes pour chaque donnée de la station météo */
    station_id UUID,              /* Identifiant de la station météo */
    measure_time TIMESTAMP,       /* Date et heure de la mesure */
    latitude DECIMAL,             /* Latitude de la station météo */
    longitude DECIMAL,            /* Longitude de la station météo */
    temperature DECIMAL,          /* Température relevée */
    humidity DECIMAL,             /* Humidité relevée */
    /* La clé primaire sera composée de l'identifiant de la station et de l'heure de mesure. */
    PRIMARY KEY ((station_id), measure_time)
) WITH CLUSTERING ORDER BY (measure_time DESC);
/* L'ordre de clustering est défini sur "measure_time" pour récupérer les dernières mesures en premier. */


/*Table de catégorisation de l'humidité en 4 catégories*/
CREATE TABLE IF NOT EXISTS WeatherDataByHumidity (
    humidity_category TEXT,
    measure_time TIMESTAMP,
    station_id UUID,
    latitude DECIMAL,
    longitude DECIMAL,
    temperature DECIMAL,
    humidity DECIMAL,
    PRIMARY KEY (humidity_category, measure_time, station_id)
) WITH CLUSTERING ORDER BY (measure_time DESC);


/*Table de catégorisation de la mesure time en 2 demi-journées */
CREATE TABLE IF NOT EXISTS WeatherDataByTime (
    day_period TEXT,
    measure_time TIMESTAMP,
    station_id UUID,
    latitude DECIMAL,
    longitude DECIMAL,
    temperature DECIMAL,
    humidity DECIMAL,
    PRIMARY KEY (day_period, measure_time, station_id)
) WITH CLUSTERING ORDER BY (measure_time DESC);

/*Table de catégorisation de la latitude en 2 hémisphères*/
CREATE TABLE IF NOT EXISTS WeatherDataByLatitude (
    hemisphere TEXT,
    measure_time TIMESTAMP,
    station_id UUID,
    latitude DECIMAL,
    longitude DECIMAL,
    temperature DECIMAL,
    humidity DECIMAL,
    PRIMARY KEY (hemisphere, measure_time, station_id)
) WITH CLUSTERING ORDER BY (measure_time DESC);


/*Ajout de quelques lignes de données pour illustrer la catégorisation de la latitude*/
INSERT INTO WeatherDataByLatitude (hemisphere, measure_time, station_id, latitude, longitude, temperature, humidity)
VALUES ('Northern', '2023-06-01 12:00:00', uuid(), 50.1234, 34.5678, 25.5, 40.0);

INSERT INTO WeatherDataByLatitude (hemisphere, measure_time, station_id, latitude, longitude, temperature, humidity)
VALUES ('Southern', '2023-06-02 09:30:00', uuid(), -35.4321, 21.8765, 28.9, 60.0);


/*Ajout de quelques lignes de données pour illustrer la catégorisation de la mesure time*/
INSERT INTO WeatherDataByTime (day_period, measure_time, station_id, latitude, longitude, temperature)
VALUES ('Morning', '2023-06-01 12:00:00',uuid(), 13.3456, 14.5678, 25.5);


/*Ajout de quelques lignes de données pour illustrer la catégorisation de la mesure time*/
INSERT INTO WeatherDataByTime (day_period, measure_time, station_id, latitude, longitude, temperature, humidity)
VALUES ('Morning', '2023-06-01 12:00:00',uuid(), 12.3456, 34.5678, 25.5, 50.0);

INSERT INTO WeatherDataByTime (day_period, measure_time, station_id, latitude, longitude, temperature, humidity)
VALUES ('Afternoon', '2023-06-02 09:30:00', uuid(), 11.4321, 21.8765, 28.9, 70.0);

/*Ajout de quelques lignes de données pour illustrer la catégorisation de l'humidité*/
INSERT INTO WeatherDataByHumidity (humidity_category, measure_time, station_id, latitude, longitude, temperature, humidity)
VALUES ('Low', '2023-06-01 12:00:00', uuid(), 12.3456, 34.5678, 25.5, 40.0);

INSERT INTO WeatherDataByHumidity (humidity_category, measure_time, station_id, latitude, longitude, temperature, humidity)
VALUES ('Medium', '2023-06-02 09:30:00', uuid(), 11.4321, 21.8765, 28.9, 60.0);


/* Pour insérer les données dans la table "WeatherData", nous utilisons la requête suivante. */
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) 
VALUES (uuid(), '2023-05-30 00:00:00', 12.9715987, 77.5945627, 27.0, 45.0);

/* Ajout de lignes dans la table WeatherData.*/
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) VALUES
  (uuid(), '2023-06-01 12:00:00', 10.1234, 20.5678, 25.5, 60.0);
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) VALUES
  (uuid(), '2023-06-02 09:30:00', 11.4321, 21.8765, 28.9, 55.2);
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) VALUES
  (uuid(), '2023-06-03 15:45:00', 9.8765, 19.5432, 26.7, 57.8);
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) VALUES
  (uuid(), '2023-06-04 08:00:00', 12.3456, NULL, 23.0, NULL);
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) VALUES
  (uuid(), '2023-06-05 14:30:00', NULL, 25.6789, NULL, 50.5);
INSERT INTO WeatherData (station_id, measure_time, latitude, longitude, temperature, humidity) VALUES
  (uuid(), '2023-06-30 18:15:00', 8.7654, 18.9876, 24.3, 62.1);


/* Pour récupérer les mesures de la table WeatherData. */

SELECT station_id, measure_time, latitude, longitude, temperature, humidity FROM WeatherData;


/* 
Utilisation des dates "measure_time" 
*/

SELECT station_id FROM WeatherData 
WHERE measure_time >= '2023-05-30 00:00:00' and measure_time <= '2023-05-31 00:00:00' ALLOW FILTERING;


/*
Sélectionner la station_id, la mesure de temps et l'humidité de la table WeatherDataByHumidity pour une station spécifique
*/
SELECT station_id, measure_time, humidity FROM WeatherDataByHumidity WHERE station_id = 28254485-e6e9-441d-8883-00c2487c0775 allow filtering;


/*
Sélectionner toutes les données de la table WeatherDataByTime
*/
SELECT day_period, measure_time,station_id,latitude,longitude,temperature, humidity FROM WeatherDataByTime;


/*
Sélectionner la station_id, la mesure de temps et la température de la table WeatherDataByTime pour une station spécifique
*/
SELECT station_id, measure_time, temperature FROM WeatherDataByTime WHERE station_id = 5d2906d1-71e8-4a27-977f-ff0e4ddcff3b allow filtering;


/*
Mettre à jour la température d'une entrée spécifique
*/
UPDATE WeatherData SET temperature = 30.2 WHERE station_id = a69730c3-0aa3-4a1f-ad0d-d69bcbce6011 AND measure_time = '2023-06-01 12:00:00';


/*
Sélectionner des données de la table WeatherDataByLatitude
*/
SELECT hemisphere, measure_time, station_id, measure_time, latitude, longitude FROM WeatherDataByLatitude;


/*
Sélectionner la station_id, la latitude et la longitude de la table WeatherDataByLatitude pour une station spécifique
*/
SELECT station_id, latitude, longitude FROM WeatherDataByLatitude;


/*
Voir les relevés ayant une humidité syupérieure à 50.
*/
select station_id, measure_time, humidity from WeatherData where humidity>50 allow filtering;


/*
Modification d'une table
*/
ALTER TABLE WeatherDataByLatitude ADD validity boolean;


/*
Voir l'état/le schéma du conteneur.
*/
select keyspace_name, durable_writes, replication from system_schema.keyspaces;


/*
Modification de tout le conteneur.
*/

alter KEYSPACE WeatherStation WITH replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 } and Durable_Writes=false;


/*Pour nettoyer le keyspace, executer le bloc ci-après.*/

/*
USE WeatherStation;
DROP TABLE IF EXISTS WeatherData;
DROP TABLE IF EXISTS WeatherDataByHumidity;
DROP TABLE IF EXISTS WeatherDataByTime;
DROP TABLE IF EXISTS WeatherDataByLatitude;
DROP KEYSPACE IF EXISTS WeatherStation;
*/
