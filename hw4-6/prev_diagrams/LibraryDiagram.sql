CREATE TABLE "Publisher" (
  "PubName" varchar PRIMARY KEY,
  "PubAddress" varchar
);

CREATE TABLE "Reader" (
  "ID" int PRIMARY KEY,
  "LastName" varchar,
  "FirstName" varchar,
  "Address" varchar,
  "BirthDate" date
);

CREATE TABLE "Book" (
  "ISBN" varchar PRIMARY KEY,
  "Title" varchar,
  "Author" varchar,
  "PagesNum" int,
  "PubYear" int,
  "PubName" varchar
);

CREATE TABLE "Category" (
  "CategoryName" varchar PRIMARY KEY,
  "ParentCat" varchar
);

CREATE TABLE "Copy" (
  "ISBN" varchar,
  "CopyNumber" int,
  "ShelfPosition" varchar,
  PRIMARY KEY ("ISBN", "CopyNumber")
);

CREATE TABLE "Borrowing" (
  "ReaderNr" int,
  "ISBN" varchar,
  "CopyNumber" int,
  "ReturnDate" date,
  PRIMARY KEY ("ReaderNr", "ISBN", "CopyNumber")
);

CREATE TABLE "BookCat" (
  "ISBN" varchar,
  "CategoryName" varchar,
  PRIMARY KEY ("ISBN", "CategoryName")
);

ALTER TABLE "Book" ADD FOREIGN KEY ("PubName") REFERENCES "Publisher" ("PubName");

ALTER TABLE "Copy" ADD FOREIGN KEY ("ISBN") REFERENCES "Book" ("ISBN");

ALTER TABLE "Borrowing" ADD FOREIGN KEY ("ReaderNr") REFERENCES "Reader" ("ID");

ALTER TABLE "Borrowing" ADD FOREIGN KEY ("ISBN", "CopyNumber") REFERENCES "Copy" ("ISBN", "CopyNumber");

ALTER TABLE "BookCat" ADD FOREIGN KEY ("ISBN") REFERENCES "Book" ("ISBN");

ALTER TABLE "BookCat" ADD FOREIGN KEY ("CategoryName") REFERENCES "Category" ("CategoryName");
