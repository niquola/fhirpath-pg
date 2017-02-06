#!/bin/bash
set -e

RESOURCE='{"a":{"b": {"c": "1980"}}}'
SEARCH_TYPES=(date number reference string token uri quantity)
SQL=""

function mk_query() {
	SEARCH_TYPE=$1
	DATA_TYPE=$2
  SQL="SELECT fhirpath_as_$SEARCH_TYPE( $DATA_TYPE);"
}

for st in "${SEARCH_TYPES[@]}"
do
	mk_query $st "bar"
	echo $SQL
done



