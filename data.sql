/* Populate database with sample data. */

----------------------------------------------------------    
/* 1-- Create table animals */
/* - Add data */
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Agumon', '2020-02-03', 0, true, 10.23),
('Gabumon', '2018-11-15', 2, true, 8),
('Pikachu', '2021-01-07', 1, false, 15.04),
('Devimon', '2017-05-12', 5, true, 11);


----------------------------------------------------------    
/* 2-- Update and delete table */
/* - Add data */
INSERT INTO animals (name, date_of_birth, weight_kg, neutered, escape_attempts)
VALUES ('Charmander', '2020-02-08', -11, false, 0),
('Plantmon', '2021-11-15', -5.7, true, 2),
('Squirtle', '1993-04-02', -12.13, false, 3),
('Angemon', '2005-06-12', -45, true, 1),
('Boarmon', '2005-06-07', 20.4, true, 7),
('Blossom', '1998-10-13', 17, true, 3),
('Ditto', '2022-05-14', 22, true, 4);

----------------------------------------------------------    
/* 3-- Query multiple tables */

---- Insert data to owners table
INSERT INTO owners (
  full_name,
  age
)
VALUES ('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

---- Insert data to species table

INSERT INTO species (name)
VALUES ('Pokemon'), ('Digimon');

---- Modify your inserted animals so it includes the species_id value;
-- 1. If the name ends in 'mon' it will be Digimon.
UPDATE animals
SET species_id = (SELECT id FROM species WHERE name = 'Digimon')
WHERE name LIKE '%mon';

-- 2. All the other animals are Pokemon

UPDATE animals SET species_id = (SELECT id FROM species WHERE name = 'Pokemon') WHERE NOT (name LIKE '%mon');

----- Modify your inserted animals so include owner information (owner_id);
