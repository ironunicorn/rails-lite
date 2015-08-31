DROP TABLE IF EXISTS houses;
DROP TABLE IF EXISTS humans;
DROP TABLE IF EXISTS cats;
DROP TABLE IF EXISTS attributes;
DROP TABLE IF EXISTS attributings;

CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  human_id INTEGER,

  FOREIGN KEY(human_id) REFERENCES humans(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  session_token VARCHAR(255)
);


INSERT INTO
  cats (name, human_id)
VALUES
  ("Little", 1),
  ("Finley", 1),
  ("Hobbes", 1);

INSERT INTO
  humans (name)
VALUES
  ("Irene");
