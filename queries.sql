/*Queries that provide answers to the questions from all projects.*/
/* 1-- Create table animals */
SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

----------------------------------------------------------------
/* 2-- Update and delete table */
----------------------------------------------------------------

/*- Update the animals table by setting the species column to unspecified*/
BEGIN;
UPDATE animals SET species = 'undefined';

/*- Verify change*/

 SELECT * FROM animals;

 /* Roll back the change and verify that the species columns went back to the state before the transaction.*/

ROLLBACK;
SELECT * FROM animals;
----------------------------------------------------------------
/* Update the animals table by setting the species column to digimon for all animals that have a name ending in mon. */
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';

/* Update the animals table by setting the species column to pokemon for all animals that don't have species already set. */
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;

/* Verify that changes were made. */
SELECT * FROM animals;

/* Commit the transations */
COMMIT;

/* Verify that changes are there after commit. */
SELECT * FROM animals;
----------------------------------------------------------------
/* Inside a transaction delete all records in the animals table, then roll back the transaction. */
BEGIN;
DELETE FROM animals;
ROLLBACK;

----------------------------------------------------------------

/* Inside a transaction*/

/* Delete all animals born after Jan 1st, 2022.*/
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

/* Create a savepoint for the transaction.*/
SAVEPOINT savepoint_before_update_animals_weight;


/* Update all animals' weight to be their weight multiplied by -1.*/
UPDATE animals SET weight_kg = weight_kg *-1;

/* Rollback to the savepoint */
ROLLBACK TO savepoint_before_update_animals_weight;

/* Update all animals' weights that are negative to be their weight multiplied by -1.*/
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

/*Commit*/

COMMIT;

----------------------------------------------------------------
-- Write queries to answer the following questions:


-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, COUNT(*) AS escape_count
FROM animals
GROUP BY neutered
ORDER BY escape_count DESC
LIMIT 1;


-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight FROM animals GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;
