-- 1

use dms_INE;

CREATE  Table region_temp
	select * FROM region r ;
	
INSERT Into dms_INE.region_temp
		(NutsID, "Level", OriginalCode, region_name, region_level)
	Values
		('PT', 0 , 0, 'PT', 'Portugal', 'Country');
	
	-- fica a faltar a entrada ParentCodeID neste insert para NutsID = PT
	-- o problema resolve-se a baixo...

SELECT * FROM region_temp WHERE region_name = 'Portugal';

INSERT Into region_temp
		(NutsID, "Level",  OriginalCode, region_name, region_level)
	values
		('ES', 0, 'ES', 'Espanha', 'country'),
		('FR', 0, 'FR', 'França', 'country');
	
		-- qual é a diferença entre '' , "" e ``?
	

SELECT * FROM region_temp rt WHERE ParentCodeID is NULL;


-- 2


UPDATE region_temp set ParentCodeID = 'EU';

SELECT * FROM  region_temp rt ;

		-- e eu a pensar que o problema se resolvia com o update
		-- here we go again

drop table region_temp;

CREATE  Table region_temp
	select * FROM region r ;

		-- nos parametros do insert selecionar o ParentCodeID e nos values colocar o correspondente
		-- não comrpreendo o pq de me estar a criar a tabela region_temp com um entrada em que Level: 0 region_name: Portugal
		-- em que o ParentCodeId = NULL

	
INSERT Into region_temp
		(NutsID, ParentCodeID ,`Level`, OriginalCode, region_name, region_level)
	Values
		('PT', 'EU', 0, 'PT', 'Portugal', 'Country'),
		('ES', 'EU', 0, 'ES', 'Espanha', 'country'),
		('FR', 'EU', 0, 'FR', 'França', 'country');
	

SELECT * FROM region_temp rt WHERE ParentCodeID is NULL ;


DELETE FROM region_temp 
	where ParentCodeID is NULL;

		-- problem solved :)

UPDATE region_temp set ParentCodeID = 'EU' Where ParentCodeID = 'EU';

		-- eu sei que é redondante é so para aplicar o 	UPDATE com o WHERE 


-- 3


		-- primeira alinea foi experimentada com o probema que tive no ex2

DELETE from region_temp WHERE region_name LIKE 'Espanha';
DELETE from region_temp WHERE region_name LIKE 'França';

SELECT * FROM region_temp rt WHERE ParentCodeID = 'EU' ;

		-- executei o codigo INSERT para recriar as entradas França e Espanha
		-- mas tambem me criou outro portugal :(

DELETE FROM region_temp WHERE region_name in ('Espanha', 'França', 'Portugal');

		-- tive de executar codigo anterior para recrir as 3 entardas
		-- e dps executar os DELETE respetivo da França e da Espanha


-- 4


select * FROM region_temp rt  WHERE  region_level  = 'freguesia';

DELETE from region_temp WHERE region_level  = 'freguesia';

		-- não existem entradas em que o region_level = freguesia na tabela region_temp

SELECT * FROM region r WHERE region_level = 'freguesia';

INSERT into region_temp 
	Select * from region WHERE region_level = 'freguesia';

select * FROM region_temp rt  WHERE  region_level  = 'freguesia';



		
	