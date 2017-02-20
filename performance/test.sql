--db:-h 127.0.0.1 -U root

---{{{
\c postgres

DROP extension if exists fhirpath;
create extension if not exists fhirpath;

------------------------
-- Query execution time
------------------------

DROP function eval_time(text);
create or replace function eval_time(query text) returns numeric as
$proc$
DECLARE
  StartTime timestamptz;
  EndTime timestamptz;
  Delta numeric;
BEGIN
	StartTime := clock_timestamp();
	execute query;
	EndTime := clock_timestamp();
	Delta := ROUND (( EXTRACT (EPOCH FROM EndTime) - EXTRACT (EPOCH FROM StartTime)) * 1000);
	return Delta;
END;
$proc$
LANGUAGE plpgsql;


------------------------
-- _as_nubmer
------------------------
create or replace function fhirpath_as_number_1() returns void as $$
BEGIN
	PERFORM fhirpath_as_number(('{"e":{"d":{"c":{"a": {"b":'||x||'}} }} }')::jsonb, '.e.d.c.a.b','integer', 'max') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function native_as_number_1() returns void as $$
BEGIN
	PERFORM ((('{"e": {"d":{"c":{"a":{"b":'||x||'}} }} }')::jsonb)#>>'{e,d,c,a,b}')::numeric as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function fhirpath_as_number_2() returns void as $$
BEGIN
	PERFORM fhirpath_as_number(('{"b": ' || x || '}')::jsonb, '.b','integer', 'max') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function native_as_number_2() returns void as $$
BEGIN
	PERFORM ((('{"b": ' || x || '}')::jsonb)#>>'{b}')::numeric as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

------------------------
-- _as_date
------------------------
create or replace function fhirpath_as_date_1() returns void as $$
BEGIN
	PERFORM fhirpath_as_date(('{"b": "2017-02-15T16:34:00.' || x || '"}')::jsonb, '.b', 'date', 'max') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function native_as_date_1() returns void as $$
BEGIN
	PERFORM ((('{"b": "2017-02-15T16:34:00.' || x || '"}')::jsonb)#>>'{b}')::date as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function fhirpath_as_date_2() returns void as $$
BEGIN
	PERFORM fhirpath_as_date(('{"e": {"d":{"c":{"a": {"b": "2017-02-15T16:34:00.' || x || '"} } } } }')::jsonb, '.e.d.c.a.b', 'date', 'max') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function native_as_date_2() returns void as $$
BEGIN
	PERFORM ((('{"e": {"d":{"c":{"a": {"b": "2017-02-15T16:34:00.' || x || '"} } } } }')::jsonb)#>>'{e,d,c,a,b}')::date as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

-------------------------
--  AS NUMBER MAX
-------------------------

DROP function number_arr_max(json);
CREATE OR REPLACE FUNCTION number_arr_max(json) RETURNS numeric AS
	'select max(i::numeric) from (select json_array_elements_text($1) as i) t'
LANGUAGE sql IMMUTABLE;

create or replace function fhirpath_as_number_max() returns void as $$
BEGIN
	PERFORM fhirpath_as_number(('{"e":{"d":{"c":{"a":{"b":['||x||','||x+1||','||x+2||','||x-8||']} } } } }')::jsonb, '.e.d.c.a.b','integer', 'max') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function native_as_number_max() returns void as $$
BEGIN
	PERFORM  number_arr_max(((('{"e": {"d":{"c":{"a": {"b":['||x||','||x+1||','||x+2||','||x-4||']}} }} }')::jsonb)#>'{e,d,c,a,b}')::json) as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

-------------------------
--  AS NUMBER MIN
-------------------------
create or replace function fhirpath_as_number_min() returns void as $$
BEGIN
	perform fhirpath_as_number(('{"e":{"d":{"c":{"a":{"b":['||x||','||x+1||','||x+2||','||x-8||']} } } } }')::jsonb, '.e.d.c.a.b','integer', 'min') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

DROP function number_arr_min(json);
CREATE OR REPLACE FUNCTION number_arr_min(json) RETURNS numeric AS
	'select min(i::numeric) from (select json_array_elements_text($1) as i) t'
LANGUAGE sql IMMUTABLE;

create or replace function native_as_number_min() returns void as $$
BEGIN
	perform  number_arr_min(((('{"e": {"d":{"c":{"a": {"b":['||x||','||x+1||','||x+2||','||x-6||']}} }} }')::jsonb)#>'{e,d,c,a,b}')::json) as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;


-------------------------
--  AS DATE MAX
-------------------------
create or replace function fhirpath_as_date_max() returns void as $$
BEGIN
	perform fhirpath_as_number(('{"b":["2017-02-15T16:34:00.' || x || '",
																		 "2017-02-15T16:35:00.' || x || '",
																		 "2017-02-15T16:36:00.' || x || '",
																		 "2017-02-15T16:37:00.' || x || '"]}')::jsonb, '.d','date', 'max') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

DROP function date_arr_max(json);
CREATE OR REPLACE FUNCTION date_arr_max(json) RETURNS date AS
	'select max(i::date) from (select json_array_elements_text($1) as i) t'
LANGUAGE sql IMMUTABLE;

create or replace function native_as_date_max() returns void as $$
BEGIN
	perform date_arr_max(((('{"b":["2017-02-15T16:34:00.' || x || '",
												 				 "2017-02-15T16:35:00.' || x || '",
																 "2017-02-15T16:36:00.' || x || '",
																 "2017-02-15T16:37:00.' || x || '"]}')::jsonb)#>'{b}')::json) as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

-------------------------
--  AS DATE MIN
-------------------------

create or replace function fhirpath_as_date_min() returns void as $$
BEGIN
	perform fhirpath_as_number(('{"b":["2017-02-15T16:34:00.' || x || '",
																		 "2017-02-15T16:35:00.' || x || '",
																		 "2017-02-15T16:36:00.' || x || '",
																		 "2017-02-15T16:37:00.' || x || '"]}')::jsonb, '.d','date', 'min') as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

-- DROP function date_arr_min(json);
-- CREATE OR REPLACE FUNCTION date_arr_min(json) RETURNS date AS
	-- 'select min(i::date) from (select json_array_elements_text($1) as i) t'
-- LANGUAGE sql IMMUTABLE;

create or replace function native_as_date_min() returns void as $$
BEGIN
	perform date_arr_min(((('{"b":["2017-02-15T16:34:00.' || x || '",
												 				 "2017-02-15T16:35:00.' || x || '",
																 "2017-02-15T16:36:00.' || x || '",
																 "2017-02-15T16:37:00.' || x || '"]}')::jsonb)#>'{b}')::json) as num
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

-------------------------
--  AS STRING
-------------------------
create or replace function fhirpath_as_string() returns void as $$
BEGIN
	PERFORM fhirpath_as_string(('{"b": "some_string_'||x||'"}')::jsonb, '.b', 'string')
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function native_as_string() returns void as $$
BEGIN
	PERFORM ((('{"b": "some_string_'||x||'"}')::jsonb)#>>'{b}')::text
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;


-------------------------
--  AS STRING CONCAT HUMAN NAME
-------------------------
DROP function humanname_concat(jsonb);
CREATE OR REPLACE FUNCTION humanname_concat(jsonb) RETURNS text AS
	'select string_agg(t.value, '' $$ '') from (select value from jsonb_each_text($1) ) t'
LANGUAGE sql IMMUTABLE;

create or replace function native_as_string_concat() returns void as $$
BEGIN
	PERFORM humanname_concat(((('{"b": {"given": ["vasya_'||x||'", "misha_'||x-1||'"], "family": ["pupkin_'||x||'"]}}')::jsonb)#>'{b}'))
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;

create or replace function fhirpath_as_string_concat() returns void as $$
BEGIN
	PERFORM fhirpath_as_string(('{"b": {"given": ["vasya_'||x||'", "misha_'||x-1||'"], "family": ["pupkin_'||x||'"]}}')::jsonb, '.b', 'HumanName')
	from generate_series(1, 100000) x;
END;
$$ LANGUAGE plpgsql;


select
	  r.method
	, r.fhirpath
	, r.native
	, r.fhirpath/r.native as "ratio fhirpath/native"

from (
	select
			f method
		,	eval_time('select fhirpath_'||f.f||'()') fhirpath
		, eval_time('select native_'||f.f||'()') native
	from (
		select unnest(array['as_number_1', 'as_number_2',
												'as_date_1', 'as_date_2',
												'as_number_min', 'as_number_max',
												'as_date_min', 'as_date_max',
												'as_string', 'as_string_concat' ]) as f
	) f
) as r

order by "ratio fhirpath/native" desc;


---}}}


---{{{
\c postgres
\timing


SELECT fhirpath_date_bound('2005-08-09',  'min');
SELECT fhirpath_date_bound('2005-08-09',  'max');

select DATERANGE('2005-08-09', '2005-08-10');


---}}}













