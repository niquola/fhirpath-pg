--db:-h 127.0.0.1 -U root


---{{{

\c postgres
\timing

select count(num) "fhirpath number .e.d.c.a.b" from (
	select fhirpath_as_number(('{"e": {"d":{"c":{"a": {"b": ' || x || '} } } } }')::jsonb, '.e.d.c.a.b','integer', 'max') as num
		from generate_series(1, 100000) x
) _ ;

select count(num) "native number {e,d,c,a,b}" from (
	select ((('{"e": {"d":{"c":{"a": {"b": ' || x || '} } } } }')::jsonb)#>>'{e,d,c,a,b}')::numeric as num
		from generate_series(1, 100000) x
) _;

select count(num) "fhirpath number .b" from (
	select fhirpath_as_number(('{"b": ' || x || '}')::jsonb, '.b','integer', 'max') as num
		from generate_series(1, 100000) x
) _ ;

select count(num) "native number {b}" from (
	select ((('{"b": ' || x || '}')::jsonb)#>>'{b}')::numeric as num
		from generate_series(1, 100000) x
) _;

select count(num) "fhirpath as_date .b" from (
	select fhirpath_as_date(('{"b": "2017-02-15T16:34:00.' || x || '"}')::jsonb, '.b', 'date', 'max') as num
		from generate_series(1, 100000) x
) _ ;

select count(num) "native date native {b}" from (
	select ((('{"b": "2017-02-15T16:34:00.' || x || '"}')::jsonb)#>>'{b}')::date as num
		from generate_series(1, 100000) x
) _;

select count(num) "fhirpath as_date .e.d.c.a.b" from (
	select fhirpath_as_date(('{"e": {"d":{"c":{"a": {"b": "2017-02-15T16:34:00.' || x || '"} } } } }')::jsonb, '.e.d.c.a.b', 'date', 'max') as num
		from generate_series(1, 100000) x
) _ ;

select count(num) "native date {e,d,c,a,b}" from (
	select ((('{"e": {"d":{"c":{"a": {"b": "2017-02-15T16:34:00.' || x || '"} } } } }')::jsonb)#>>'{e,d,c,a,b}')::date as num
		from generate_series(1, 100000) x
) _;



---}}}



---{{{
\c postgres
\timing

CREATE OR REPLACE FUNCTION arr_max(json) RETURNS numeric AS
'select max(i::numeric) from (select json_array_elements_text($1) as i) t' LANGUAGE sql IMMUTABLE;

--select count(num) "fhirpath number .e.d.c.a.b" from (
select count(*) from (
	select fhirpath_as_number(('{"e": {"d":{"c":{"a": {"b": [' || x || ', ' || x+1 || ', ' || x+2 || ']} } } } }')::jsonb, '.e.d.c.a.b','integer', 'max') as num
		from generate_series(1, 1000000) x
) _ ;

---select count(num) "native number {e,d,c,a,b}" from (
select * from (
	 select  arr_max(((('{"e": {"d":{"c":{"a": {"b":['||x||','||x+1||','||x+2||','||x-8||']}} }} }')::jsonb)#>'{e,d,c,a,b}')::json) as num

	 -- select json_array_elements(
			-- (('{"e": {"d":{"c":{"a":{"b":['||x||','||x+1||','||x+2||']}} }} }')::jsonb)#>'{e,d,c,a,b}'
	 -- ) as num
	 from generate_series(1, 10) x
) _;


select 1;

---}}}

---{{{

\c postgres
\timing
select count(num) "fhirpath number .e.d.c.a.b" from (
	select fhirpath_as_number(('{"e": {"d":{"c":{"a": {"b": ' || x || '} } } } }')::jsonb, '.e.d.c.a.b','integer', 'max') as num
		from generate_series(1, 100000) x
) _ ;

select count(num) "native number {e,d,c,a,b}" from (
	select ((('{"e": {"d":{"c":{"a": {"b": ' || x || '} } } } }')::jsonb)#>>'{e,d,c,a,b}')::numeric as num
		from generate_series(1, 100000) x
) _;

DO $proc$
DECLARE
  StartTime timestamptz;
  EndTime timestamptz;
  Delta interval;
BEGIN
  StartTime := clock_timestamp();

	perform count(num) "fhirpath number .e.d.c.a.b" from (
	select fhirpath_as_number(('{"e": {"d":{"c":{"a": {"b": ' || x || '} } } } }')::jsonb, '.e.d.c.a.b','integer', 'max') as num
		from generate_series(1, 100000) x
) _ ;

  EndTime := clock_timestamp();
  Delta := ( extract(epoch from EndTime) - extract(epoch from StartTime) );
  RAISE NOTICE 'Duration in millisecs=%', Delta;
END;
$proc$;

DO $proc$
DECLARE
  StartTime timestamptz;
  EndTime timestamptz;
  Delta interval;
BEGIN
  StartTime := clock_timestamp();

	perform count(num) "native number {e,d,c,a,b}" from (
	select ((('{"e": {"d":{"c":{"a": {"b": ' || x || '} } } } }')::jsonb)#>>'{e,d,c,a,b}')::numeric as num
		from generate_series(1, 100000) x
) _;

  EndTime := clock_timestamp();
  Delta := ( extract(epoch from EndTime) - extract(epoch from StartTime) );
  RAISE NOTICE 'Duration in millisecs=%', Delta;
END;
$proc$;



---}}}
