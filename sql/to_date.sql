SELECT fhirpath_as_date('{"a":{"b": {"c": "1980"}}}', '.a.b.c', 'date', 'min');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02"}}}', '.a.b.c', 'date', 'min');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05"}}}', '.a.b.c', 'date', 'min');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08"}}}', '.a.b.c', 'date', 'min');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30"}}}', '.a.b.c', 'date', 'min');

SELECT fhirpath_as_date('{"a":["1980-02-05T08:30", "1976-01", "1952-02-03"]}', '.a', 'date', 'min');

SELECT fhirpath_as_date('{"a":{"b": {"c": "1980"}}}', '.a.b.c', 'date', 'max');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02"}}}', '.a.b.c', 'date', 'max');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05"}}}', '.a.b.c', 'date', 'max');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08"}}}', '.a.b.c', 'date', 'max');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30"}}}', '.a.b.c', 'date', 'max');
SELECT fhirpath_as_date('{"a":{"b": {"c": "1980-02-05T08:30+05"}}}', '.a.b.c', 'date', 'max');

SELECT fhirpath_as_date('{"a":["1980-02-05T08:30", "1976-01", "1952-02-03"]}', '.a', 'date', 'max');

--- time
SELECT fhirpath_as_date('{"time": "11:00:00" }', '.time', 'time' , 'max');
SELECT fhirpath_as_date('{"time": "11:00:00" }', '.time', 'time' , 'min');
SELECT fhirpath_as_date('{"time": "23:59:59" }', '.time', 'time' , 'max');
SELECT fhirpath_as_date('{"time": "00:00:01" }', '.time', 'time' , 'min');

SELECT fhirpath_as_date('{"time": ["11:00:00", "12:00:00", "13:00:00"] }', '.time', 'time' , 'max');
SELECT fhirpath_as_date('{"time": ["11:00:00", "12:00:00", "13:00:00"] }', '.time', 'time' , 'min');
SELECT fhirpath_as_date('{"time": ["23:59:59", "11:00:00", "12:00:00"] }', '.time', 'time' , 'max');
SELECT fhirpath_as_date('{"time": ["00:00:01", "11:00:00", "12:00:00"] }', '.time', 'time' , 'min');



--- Timing


SELECT fhirpath_as_date('{"timing": {"event": ["1992-12-31"]}}', '.timing', 'Timing' , 'max');
SELECT fhirpath_as_date('{"timing": {"event": ["1991-01-01"]}}', '.timing', 'Timing' , 'min');
SELECT fhirpath_as_date('{"timing": {"event": ["1991-01-01", "1992-12-31"]}}', '.Timing.value', 'Timing' , 'max');
SELECT fhirpath_as_date('{"timing": {"event": ["1991-01-01", "1992-12-31"]}}', '.Timing.value', 'Timing' , 'min');

select '''{
  "Timing":{
    "value": {"event": ["1991-01-01", "1992-01-01"]},
    "array": [{"event": ["1991-01-01"]},
						  {"event": ["2000-01-01", "1990-01-01"]},
						  {"event": ["1992-01-01"]}],
    "where": [{ "code": "value", "value": {"event": ["1991-01-01", "1992-01-01"]} },
              { "code": "array", "array": [{"event": ["1991-01-01"]},
																					 {"event": ["2000-01-01", "1990-01-01"]},
																					 {"event": ["1992-01-01"]}] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"event": ["1991-01-01", "1992-01-01"]}},
                           {"code": "array", "array": [{"event": ["1991-01-01"]},
																											 {"event": ["2000-01-01", "1990-01-01"]},
																											 {"event": ["1992-01-01"]}]} ] } ] }
}''' resource \gset
SELECT fhirpath_as_date(:resource, '.Timing.value', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.array', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=value).value', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=array).array', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=where).where.where(code=value).value', 'Timing' , 'max');
SELECT fhirpath_as_date(:resource, '.Timing.where.where(code=where).where.where(code=array).array', 'Timing' , 'max');

--- Period
select '''{
  "Period":{
    "value": {"start": "1991-01-01", "end": "1991-12-31"},
    "array": [{"start": "1991-01-01", "end": "1991-12-31"},
 						  {"start": "1990-01-01", "end": "1991-12-31"},
							{"start": "1981-01-01"}],
    "where": [{ "code": "value", "value": {"start": "1991-01-01", "end": "1991-12-31"} },
              { "code": "array", "array": [{"start": "1991-01-01", "end": "1991-12-31"},
																					 {"start": "1990-01-01", "end": "1991-12-31"},
																					 {"start": "1981-01-01"}] },
              { "code": "where",
                "where": [ {"code": "value", "value": {"start": "1991-01-01", "end": "1991-12-31"}},
                           {"code": "array", "array": [{"start": "1991-01-01", "end": "1991-12-31"},
																											 {"start": "1990-01-01", "end": "1991-12-31"},
																											 {"start": "1981-01-01"}]} ] } ] }
}''' resource \gset

SELECT fhirpath_as_date(:resource, '.Period.value', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.array', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=value).value', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=array).array', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=where).where.where(code=value).value', 'Period' , 'max');
SELECT fhirpath_as_date(:resource, '.Period.where.where(code=where).where.where(code=array).array', 'Period' , 'max');
