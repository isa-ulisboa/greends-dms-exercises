use dms_IneV1;

SELECT * from region r ;

describe region ;

-- apagar a coluna
	ALTER TABLE region DROP COLUMN OriginalCode;

-- criar a tabela region_level
	drop table if exists region_level;

	CREATE TABLE region_level (level_ID INT PRIMARY KEY)
	SELECT DISTINCT `Level` as level_ID, region_level FROM region r ;

-- verificar se a tabela foi criada
	SELECT * from region_level;
	describe region_level;

-- alterar NUST para NUTS (valores dentro da tabela)
	UPDATE region_level  set region_level = REPLACE (region_level, 'NUST', 'NUTS')
	where region_level like 'NUST%';
	
-- aleterar nome uma coluna
	ALTER table region 
	RENAME COLUMN `Level` TO `level_ID`;

-- apagar coluna
	ALTER table region 
	DROP column region_level; 

-- defenir chave estrangeira
	ALTER TABLE region 
	ADD FOREIGN KEY (level_ID) REFERENCES region_level(level_ID);

-- verificar se a os NutsId são unicos
	SELECT NutsID from region r group by NutsID having COUNT(*)>1; 
		
		-- sendo uma lista vazia confirma-se a sua singularidade

-- defenir NutsId como chave primaéria
	ALTER TABLE region 
	ADD PRIMARY KEY (NutsID);


SELECT * FROM region r INNER JOIN region_level rl ON r.level_ID = rl.level_ID ;

SELECT * from production p;
describe production ;

-- Q1
	-- defenir chave primária
	-- estabelecer relaçao com NutsID atraves da chave secundária
	-- eliminra NutsID

ALTER TABLE production
ADD COLUMN `production_ID` INT NOT NULL AUTO_INCREMENT,
DROP COLUMN region_name,
ADD PRIMARY KEY (production_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);


SELECT * FROM education ;
DESCRIBE education ;

-- Q2
	-- criar um tabela, education_level
	-- adicionar auma coluna education_Level_ID
	-- estabelcer a chave primaria em na tabela educação
	-- estabelecer relaçao com NutsID atraves da chave secundária

-- remove a table if exists
DROP TABLE IF EXISTS education_level;

-- create the table to contain education level categories
CREATE TABLE education_level (education_level_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT education_level FROM education e ;

-- check it was created
SELECT * FROM education_level;

-- make the changes in table education, all in the same statement
ALTER TABLE education
ADD COLUMN `education_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN education_level_ID INT,
ADD PRIMARY KEY (education_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- we need to update table education, adding values to column education_level_ID
UPDATE education e, education_level el SET e.education_level_ID = el.education_level_ID 
WHERE e.education_level = el.education_level;

-- delete column education_level from education 
ALTER TABLE education 
DROP COLUMN education_level;

-- add foreign key on education_level_ID
ALTER TABLE education 
ADD FOREIGN KEY (education_level_ID) REFERENCES education_level(education_level_ID);


SELECT * from permanent_crop pc;
describe permanent_crop 

-- Q3
	-- criara chave primária
	-- estabelecer relaçao com NutsID atraves da chave secundária
	-- eliminara a dependencia parcial eleiminando as colunas region_name e region_level
	-- criar tabela permanet_crop_name
	-- criar coluna permament_crop_ID que echave secunadaria na tabela permanent crop

DROP TABLE IF EXISTS permanent_crop_name;

CREATE TABLE permanent_crop_name (pc_name_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
SELECT DISTINCT crop_name FROM permanent_crop ;

SELECT * FROM permanent_crop_name;

ALTER TABLE permanent_crop
ADD COLUMN `permanent_crop_ID` INT NOT NULL AUTO_INCREMENT,
ADD COLUMN pc_name_ID INT,
ADD PRIMARY KEY (permanent_crop_ID),
ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);

-- add values to column permanent_crop_ID in permanent_crop table
UPDATE permanent_crop l, permanent_crop_name tl SET l.pc_name_ID = tl.pc_name_ID 
WHERE l.crop_name = tl.crop_name;

-- delete column crop_name from permanent_crop and set the foreign key
ALTER TABLE permanent_crop 
DROP COLUMN crop_name,
ADD FOREIGN KEY (pc_name_ID) REFERENCES permanent_crop_name(pc_name_ID);

-- remove columns with partial dependency
ALTER TABLE permanent_crop 
DROP COLUMN region_name,
DROP COLUMN region_level;



SELECT * from temporary_crop tc ;
describe temporary_crop ;

-- Q3
	-- aplicar absiacemnete as mesma mudanças que foram realizadas na table permanent_crop
	-- defnir chave primeria
	-- estabelecer relações  atraves da NutsID
	-- criar um tabela secundaria para temp_crop_ID e respetiva corres podendencia
	-- eleiminar crop_name, region_name e region_level, adicionar temp_crop_Id

-- Q4

-- create table
 CREATE TABLE temporary_crop_name (tc_name_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
 SELECT DISTINCT crop_name FROM temporary_crop;
 -- select table created to check
 SELECT * FROM temporary_crop_name;
 -- change table temporary_crop
 ALTER TABLE temporary_crop
 ADD COLUMN `temporary_crop_ID` INT NOT NULL AUTO_INCREMENT,
 ADD COLUMN tc_name_ID INT,
 DROP COLUMN region_name,
 DROP COLUMN region_level,
 ADD PRIMARY KEY (temporary_crop_ID),
 ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);
 -- add values to column temporary_crop_ID in temporary_crop table
 UPDATE temporary_crop l, temporary_crop_name tl SET l.tc_name_ID = tl.tc_name_ID 
 WHERE l.crop_name = tl.crop_name;
 -- delete column crop_name from temporary_crop 
 ALTER TABLE temporary_crop 
 DROP COLUMN crop_name,
 ADD FOREIGN KEY (tc_name_ID) REFERENCES temporary_crop_name(tc_name_ID);



-- Q5

-- Grassland

 ALTER TABLE grassland 
 ADD COLUMN `grassland_ID` INT NOT NULL AUTO_INCREMENT,
 ADD PRIMARY KEY (grassland_ID),
 ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID),
 DROP COLUMN region_name,
 DROP COLUMN region_level;


 -- Labour

 SELECT * FROM labour;
 DROP TABLE IF EXISTS type_labour_name;
 CREATE TABLE type_labour_name (type_labour_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT);
 SELECT DISTINCT type_labour FROM labour l;
 ALTER TABLE labour ADD COLUMN type_labour_ID INT,
 ADD COLUMN `labour_ID` INT NOT NULL AUTO_INCREMENT,
 ADD PRIMARY KEY (labour_ID),
 ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);
 UPDATE labour l, type_labour_name tln SET l.type_labour_ID = tln.type_labour_ID
 WHERE l.type_labour = tln.type_labour;


 -- Livestock

 SELECT * FROM livestock l;
 DROP TABLE IF EXISTS livestock_name;
 CREATE TABLE livestock_name (livestock_name_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT)
 SELECT DISTINCT animal_species FROM livestock l;
 ALTER TABLE livestock ADD COLUMN livestock_name_ID INT,
 ADD COLUMN `livestock_ID` INT NOT NULL AUTO_INCREMENT,
 ADD PRIMARY KEY (livestock_ID),
 ADD FOREIGN KEY (NutsID) REFERENCES region(NutsID);
 SELECT * FROM livestock;
 UPDATE livestock l, livestock_name lsn SET l.livestock_name_ID = lsn.livestock_name_ID 
 WHERE l.animal_species = lsn.animal_species;
 ALTER TABLE livestock 
 ADD FOREIGN KEY (livestock_name_ID) REFERENCES livestock_name(livestock_name_ID),
 DROP COLUMN animal_species;

