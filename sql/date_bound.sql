SELECT fhirpath_date_bound('1980', 'min'); 
SELECT fhirpath_date_bound('1980-02', 'min'); 
SELECT fhirpath_date_bound('1980-02-05','min'); 
SELECT fhirpath_date_bound('1980-02-05T08', 'min'); 
SELECT fhirpath_date_bound('1980-02-05T08:30', 'min'); 

SELECT fhirpath_date_bound('1980', 'max'); 
SELECT fhirpath_date_bound('1980-02', 'max'); 
SELECT fhirpath_date_bound('1980-02-05','max'); 
SELECT fhirpath_date_bound('1980-02-05T08', 'max'); 
SELECT fhirpath_date_bound('1980-02-05T08:30', 'max'); 


select fhirpath_date_bound('2000-01-01', 'min');
select fhirpath_date_bound('2000-01-01', 'max');
