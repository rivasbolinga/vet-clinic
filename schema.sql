/* Database schema to keep the structure of entire database. */

/* 1-- Create table animals */

CREATE TABLE animals (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg FLOAT NOT NULL,
);

/* 2-- Update and delete table */

/* - Add new column called species of type string */
ALTER TABLE animals ADD COLUMN species VARCHAR(50);
    
