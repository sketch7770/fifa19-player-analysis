select * from fifa19 limit 10  ;
describe fifa19;
alter table fifa19 
add column value_num float  ;

update fifa19
set value_num =
	case
		when Value like '%M' then 
			cast(replace(replace(value ,'€', '') , 'M' , '') as float ) * 1000000
        when Value like '%K' then 
			cast(replace(replace(value ,'€', '') , 'K' , '') as float ) * 1000    
	end ;
    

alter table fifa19 
add column wage_num float  ;
update fifa19
set wage_num =
	case
		when Wage like '%K' then 
			cast(replace(replace(Wage ,'€', '') , 'K' , '') as float ) * 1000
	end ;



alter table fifa19 
add column release_clause_num float  ;
update fifa19
set release_clause_num=
	case
		when `Release Clause` like '%M' then 
			cast(replace(replace(`Release Clause` ,'€', '') , 'M' , '') as float ) * 1000000
        when `Release Clause` like '%K' then 
			cast(replace(replace(`Release Clause` ,'€', '') , 'K' , '') as float ) * 1000    
	end ;
    
    
    
alter table fifa19 
add column height_cm float  ; 
update fifa19
set height_cm=
		(cast(substring_index(height , '''' , 1) AS UNSIGNED) * 30.48) +
        (cast(substring_index(height , ''''  , -1) AS UNSIGNED)*  2.54)  ;

alter table fifa19 
add column weight_kg float  ; 
update fifa19
set weight_kg=
		cast(replace(weight , 'lbs' , '') as Float) *0.453592  ;
        
alter table fifa19 
add column joined_date date  ; 
update  fifa19
set joined_date = str_to_date(joined , '%b %d, %Y') ;
	
alter table fifa19 
add column attack_rate varchar(20)  , 
add column defense_rate varchar(20) ;
update fifa19
set 
	attack_rate = substring_index(`work rate` , '/' , 1) ,
	defense_rate = substring_index(`work rate` , '/' , -1) ;
    
update fifa19
set 
	name = replace(name , '?' , '')  ,
	Nationality =replace(Nationality, '?' , '')  ,
    Club =replace(replace(Club, '?' , '')  , '1.' ,'') ;

select count(*)
from fifa19 ;

alter table fifa19
add column experience int ;
update fifa19 
set experience = year(current_date()) - year(joined_date) ;

update  fifa19 
set `body type` = 'unknown' 
where `body type` in ('akinfenwa' , 'c. ronaldo' , 'courtosi' , 'messi' ,'neymar' ,'player_body_type_25' , 'shaqiri' , 'stocky') ;

select name , wage_num , experience from fifa19
order by wage_num desc
limit 10;

select club , floor(avg(age)) as avg_age from fifa19
group by club 
order by avg_age desc  ;

select age , floor(avg(value_num)) as avg_value from fifa19 
group by age
order by avg_value desc ;

select attack_rate , floor(avg(value_num)) as value_avg from fifa19 
group by attack_rate 
order by value_avg desc ;

select defense_rate , floor(avg(value_num)) as value_avg from fifa19 
group by defense_rate 
order by value_avg desc ;

select   experience, floor(avg(wage_num)) as wage_avg  from fifa19
group by experience
order by wage_avg desc;


SELECT * FROM fifa19
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fifa19.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


SHOW VARIABLES LIKE 'secure_file_priv';