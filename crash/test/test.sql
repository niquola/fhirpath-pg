select '''{
  "integer":{
    "value": 40,
    "array": [40, 41, 39],
    "where": [
      {
        "code": "value", "value": 42
      }, {
        "code": "array", "array": [41, 43, 42]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 44},
          {"code": "array", "array": [43, 45, 44]}
        ]
      }
    ]
  },
  "unsignedInt":{
    "value": 46,
    "array": [46, 47, 45],
    "where": [
      {
        "code": "value", "value": 48
      }, {
        "code": "array", "array": [48, 49, 47]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 50},
          {"code": "array", "array": [49, 51, 50]}
        ]
      }
    ]
  },
  "positiveInt":{
    "value": 52,
    "array": [41, 53, 43],
    "where": [
      {
        "code": "value", "value": 54
      }, {
        "code": "array", "array": [45, 55, 47]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 56},
          {"code": "array", "array": [49, 57, 31]}
        ]
      }
    ]
  }
}''' resource \gset
create or replace function r(error_message text) returns void as $$
				begin
					raise info '%', error_message;
				end;
			$$ language plpgsql;
DO language plpgsql $$ BEGIN RAISE info 'number .integer.value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=value).value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=value).value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=array).array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=array).array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=where).where.where(code=value).value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=where).where.where(code=value).value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.where.where(code=where).where.where(code=array).array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.where.where(code=where).where.where(code=array).array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=value).value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=value).value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=array).array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=array).array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=where).where.where(code=value).value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=where).where.where(code=value).value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.where.where(code=where).where.where(code=array).array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.where.where(code=where).where.where(code=array).array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.array', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=value).value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=value).value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=array).array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=array).array', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=where).where.where(code=value).value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=where).where.where(code=value).value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.where.where(code=where).where.where(code=array).array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.where.where(code=where).where.where(code=array).array', 'positiveInt' , 'max');
