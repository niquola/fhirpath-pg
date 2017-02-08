select '''{
  "integer":{
    "value": 40,
    "array": [41, 42, 43],
    "wheres": [
      {
        "code": "value", "value": 44
      }, {
        "code": "array", "array": [45, 46, 47]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 48},
          {"code": "array", "array": [49, 50, 60]}
        ]
      }
    ]
  },
  "unsignedInt":{
    "value": 50,
    "array": [51, 52, 53],
    "where": [
      {
        "code": "value", "value": 55
      }, {
        "code": "array", "array": [55, 56, 57]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 58},
          {"code": "array", "array": [59, 60, 61]}
        ]
      }
    ]
  },
  "positiveInt":{
    "value": 60,
    "array": [61, 62, 63],
    "where": [
      {
        "code": "value", "value": 66
      }, {
        "code": "array", "array": [65, 66, 67]
      }, {
        "code": "where",
        "where": [
          {"code": "value", "value": 68},
          {"code": "array", "array": [69, 70, 71]}
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
DO language plpgsql $$ BEGIN RAISE info 'number .integer.wheres.where(code=value).value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.wheres.where(code=value).value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.wheres.where(code=array).array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.wheres.where(code=array).array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.wheres.where(code=where).where.where(code=value).value integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.wheres.where(code=where).where.where(code=value).value', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .integer.wheres.where(code=where).where.where(code=array).array integer'; END $$;
SELECT fhirpath_as_number(:resource, '.integer.wheres.where(code=where).where.where(code=array).array', 'integer' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.wheres.where(code=value).value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.wheres.where(code=value).value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.wheres.where(code=array).array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.wheres.where(code=array).array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.wheres.where(code=where).where.where(code=value).value unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.wheres.where(code=where).where.where(code=value).value', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .unsignedInt.wheres.where(code=where).where.where(code=array).array unsignedInt'; END $$;
SELECT fhirpath_as_number(:resource, '.unsignedInt.wheres.where(code=where).where.where(code=array).array', 'unsignedInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.array', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.wheres.where(code=value).value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.wheres.where(code=value).value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.wheres.where(code=array).array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.wheres.where(code=array).array', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.wheres.where(code=where).where.where(code=value).value positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.wheres.where(code=where).where.where(code=value).value', 'positiveInt' , 'max');
DO language plpgsql $$ BEGIN RAISE info 'number .positiveInt.wheres.where(code=where).where.where(code=array).array positiveInt'; END $$;
SELECT fhirpath_as_number(:resource, '.positiveInt.wheres.where(code=where).where.where(code=array).array', 'positiveInt' , 'max');
