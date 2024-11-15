CREATE DATABASE notes_app;
USE notes_app;

CREATE TABLE notes(id integer PRIMARY KEY AUTO_INCREMENT,
title VARCHAR(250) NOT NULL,contents TEXT NOT NULL,
created TIMESTAMP NOT NULL DEFAULT NOW()
);

INSERT INTO notes(title,contents) 
VALUES
('My first node','A note about something'),
('My seond node','Another note about something');