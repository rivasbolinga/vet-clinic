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
----------------------------------------------------------------
/* 3-- Query multiple tables */
----------------------------------------------------------------

-- What animals belong to Melody Pond?
SELECT name FROM animals
WHERE owner_id = (SELECT id FROM owners WHERE full_name = 'Melody Pond');

 -- List of all animals that are pokemon (their type is Pokemon).
 SELECT * FROM animals
WHERE species_id = (SELECT id FROM species WHERE name = 'Pokemon');

  -- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;

  -- How many animals are there per species?
SELECT species.name, COUNT(*)
FROM species
JOIN animals ON animals.species_id = species.id
GROUP BY species.name;

  -- List all Digimon owned by Jennifer Orwell.
SELECT * FROM animals WHERE owner_id = (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell') AND species_id = (SELECT id  FROM species WHERE name = 'Digimon');

  -- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM animals WHERE owner_id = (SELECT id FROM owners WHERE full_name = 'Dean Winchester') AND escape_attempts = 0;

  -- Who owns the most animals?
SELECT owners.full_name, COUNT(*) FROM owners JOIN animals ON animals.owner_id = owners.id GROUP BY owners.full_name ORDER BY COUNT(*) DESC
LIMIT 1;

----------------------------------------------------------------
/* 4-- Add JOIN TABLE for visits */
----------------------------------------------------------------

-- Who was the last animal seen by William Tatcher?
SELECT animals.name FROM animals JOIN visits ON visits.animal_id = animals.id WHERE vet_id = (SELECT id FROM vets WHERE name = 'William Tatcher') ORDER BY visit_date DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT visits.animal_id) FROM visits WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez');

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name, species.name FROM vets LEFT JOIN specializations ON vets.id = specializations.vet_id LEFT JOIN species ON species.id = specializations.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT name FROM animals JOIN visits ON visits.animal_id = animals.id WHERE vet_id = (SELECT id FROM vets WHERE name = 'Stephanie Mendez') AND visit_date BETWEEN '2020-04-01' AND '2020-08-30';

--What animal has the most visits to vets?
SELECT animals.name, COUNT(visits.animal_id) AS visit_count
FROM animals
JOIN visits ON animals.id = visits.animal_id
GROUP BY animals.name
ORDER BY visit_count DESC
LIMIT 1;

--Who was Maisy Smith's first visit?
SELECT animals.name FROM animals JOIN visits ON visits.animal_id = animals.id WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith') ORDER BY visit_date ASC LIMIT 1;


--Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, animals.date_of_birth, animals.escape_attempts, animals.neutered, animals.weight_kg, animals.species_id, animals.owner_id, vets.name, vets.date_of_graduation, vets.age, visits.visit_date FROM visits LEFT JOIN animals ON animals.id = visits.animal_id LEFT JOIN vets ON vets.id = visits.vet_id ORDER BY visit_date DESC LIMIT 1;

--How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM visits LEFT JOIN specializations ON visits.vet_id = specializations.vet_id LEFT JOIN species ON species.id = specializations.species_id WHERE specializations.vet_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name
FROM species
JOIN animals ON animals.species_id = species.id
JOIN visits ON visits.animal_id = animals.id
JOIN vets ON vets.id = visits.vet_id
WHERE vet_id = (SELECT id FROM vets WHERE name = 'Maisy Smith')
GROUP BY species.name
ORDER BY COUNT(*) DESC
LIMIT 1;