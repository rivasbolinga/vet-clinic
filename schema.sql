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

----------------------------------------------------------
/* 2-- Update and delete table */

-- Add new column called species of type string
ALTER TABLE animals ADD COLUMN species VARCHAR(50);

----------------------------------------------------------    
/* 3-- Query multiple tables */

--Create a table named owners with the following columns: id as integer (set it as autoincremented primary key), full_name as string and age as integer.
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    age INT NOT NULL
);

--Create a table named species with the following columns; id as integer (set it as autoincremented primary key), name as string.

CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Modify animals table: 

-----Remove column species
ALTER TABLE animals DROP COLUMN species;

----Add column species_id which is a foreign key referencing species table;
ALTER TABLE animals ADD COLUMN species_id INT REFERENCES species(id);

----Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals ADD COLUMN owner_id INT REFERENCES owners(id);

----------------------------------------------------------    
/* 4-- Add JOIN TABLE for visits */

-- Create vets table.
CREATE TABLE vets (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

--  Create a join table called specializations to handle the relationship between vets and species.

CREATE TABLE specializations (
    vet_id INTEGER,
    species_id INTEGER,
    FOREIGN KEY (vet_id) REFERENCES vets(id),
    FOREIGN KEY (species_id) REFERENCES species(id),
    PRIMARY KEY (vet_id, species_id)
);

-- Add a unique constraint to the "id" column in the "animals" table
ALTER TABLE animals
ADD CONSTRAINT animals_id_key UNIQUE (id);


--  Create a join table called specializations to handle the relationship between vets and animals.

CREATE TABLE visits (
    vet_id INTEGER NOT NULL,
    animal_id INTEGER NOT NULL,
    visit_date DATE NOT NULL,
    CONSTRAINT fk_visits_animals
        FOREIGN KEY (animal_id) REFERENCES animals (id),
    CONSTRAINT fk_visits_vets
        FOREIGN KEY (vet_id) REFERENCES vets (id),
    PRIMARY KEY (vet_id, animal_id, visit_date)
);

----------------------------------------------------------    
/* 5-- Database performance Audit */

-- Add an email column to your owners table
ALTER TABLE owners ADD COLUMN email VARCHAR(120);