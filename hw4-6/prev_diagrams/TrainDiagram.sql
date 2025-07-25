CREATE TABLE "City" (
  "Name" varchar,
  "Region" varchar,
  PRIMARY KEY ("Name", "Region")
);

CREATE TABLE "Station" (
  "Name" varchar PRIMARY KEY,
  "Tracks" int,
  "CityName" varchar,
  "Region" varchar
);

CREATE TABLE "Train" (
  "TrainNr" int PRIMARY KEY,
  "Length" int,
  "StartStationName" varchar,
  "EndStationName" varchar
);

CREATE TABLE "Connection" (
  "FromStation" varchar,
  "ToStation" varchar,
  "TrainNr" int,
  "Departure" time,
  "Arrival" time,
  PRIMARY KEY ("FromStation", "ToStation", "TrainNr", "Departure", "Arrival")
);

ALTER TABLE "Station" ADD FOREIGN KEY ("CityName", "Region") REFERENCES "City" ("Name", "Region");

ALTER TABLE "Train" ADD FOREIGN KEY ("StartStationName") REFERENCES "Station" ("Name");

ALTER TABLE "Train" ADD FOREIGN KEY ("EndStationName") REFERENCES "Station" ("Name");

ALTER TABLE "Connection" ADD FOREIGN KEY ("FromStation") REFERENCES "Station" ("Name");

ALTER TABLE "Connection" ADD FOREIGN KEY ("ToStation") REFERENCES "Station" ("Name");

ALTER TABLE "Connection" ADD FOREIGN KEY ("TrainNr") REFERENCES "Train" ("TrainNr");
