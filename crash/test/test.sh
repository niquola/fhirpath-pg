#!/bin/bash
set -e

source ./test.cfg

RESOURCE=$(<resource.json)


function mk_query() {
	local SEARCH_TYPE=$1
  local PTH=$2
  local	DATA_TYPE=$3
	local MODIFICATION=""

	if [ "$SEARCH_TYPE" == number ] || [ "$SEARCH_TYPE" == date ]
  then
    MODIFICATION=", 'max'"
  fi

  echo "SELECT fhirpath_as_$SEARCH_TYPE(:resource, '$PTH', '$DATA_TYPE' $MODIFICATION);"
}

function gen_pths() {
  local	data_type=$1
  local paths=()
  paths+=(".$data_type.value")
  paths+=(".$data_type.array")
  paths+=(".$data_type.where(code=value).value")
  paths+=(".$data_type.where(code=array).array")
  paths+=(".$data_type.where(code=where).where.where(code=value).value")
  paths+=(".$data_type.where(code=where).where.where(code=array).array")
	echo "${paths[@]}"
}


echo "select '''$RESOURCE''' resource \\gset"

for data_type in "${NUMBER[@]}"
do
  paths=($(gen_pths $data_type))
  for path in "${paths[@]}"
  do
    mk_query "number" $path $data_type
  done
done


