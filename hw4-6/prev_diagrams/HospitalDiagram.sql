CREATE TABLE "StationPersonell" (
  "PersNr" int PRIMARY KEY,
  "Name" varchar,
  "StatNr" int
);

CREATE TABLE "CareGiver" (
  "PersNr" int PRIMARY KEY,
  "Qualification" varchar
);

CREATE TABLE "Doctor" (
  "PersNr" int PRIMARY KEY,
  "Area" varchar,
  "Rank" varchar
);

CREATE TABLE "Station" (
  "StatNr" int PRIMARY KEY,
  "Name" varchar
);

CREATE TABLE "Room" (
  "RoomNr" int PRIMARY KEY,
  "Beds" int,
  "StatNr" int
);

CREATE TABLE "Patient" (
  "PatientNr" int PRIMARY KEY,
  "Name" varchar,
  "Disease" varchar
);

CREATE TABLE "Admission" (
  "AdmissionID" int PRIMARY KEY,
  "From" date,
  "To" date,
  "RoomNr" int,
  "PatientNr" int
);

ALTER TABLE "CareGiver" ADD FOREIGN KEY ("PersNr") REFERENCES "StationPersonell" ("PersNr");

ALTER TABLE "Doctor" ADD FOREIGN KEY ("PersNr") REFERENCES "StationPersonell" ("PersNr");

ALTER TABLE "Room" ADD FOREIGN KEY ("StatNr") REFERENCES "Station" ("StatNr");

ALTER TABLE "Admission" ADD FOREIGN KEY ("RoomNr") REFERENCES "Room" ("RoomNr");

ALTER TABLE "Admission" ADD FOREIGN KEY ("PatientNr") REFERENCES "Patient" ("PatientNr");

ALTER TABLE "Doctor" ADD FOREIGN KEY ("PersNr") REFERENCES "Patient" ("PatientNr");

ALTER TABLE "StationPersonell" ADD FOREIGN KEY ("StatNr") REFERENCES "Station" ("StatNr");
