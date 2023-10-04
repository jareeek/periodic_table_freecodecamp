#!/bin/bash

PSQL="psql -X -A -U freecodecamp -d periodic_table --tuples-only -c"

if [[ ! $1 ]] 
then
  echo "Please provide an element as an argument."
else
  re='^[0-9]+$'
  if [[ $1 =~ $re ]]
  then
    # echo It\'s a number
    SEL_ELEMENT=$($PSQL "select * from elements join properties\
    using(atomic_number) join types using (type_id) where atomic_number=$1;")
  else
    # echo It\'s a varchar
    SEL_ELEMENT=$($PSQL "select * from elements join properties\
    using(atomic_number) join types using (type_id) where symbol='$1' or name='$1';")
  fi
  if [[ -z $SEL_ELEMENT ]]
  then
    echo I could not find that element in the database.
  else
  echo $SEL_ELEMENT | while IFS="|" read type_id number symbol name mass melt boil type
    do
      echo "The element with atomic number $number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melt celsius and a boiling point of $boil celsius."
    done
  fi
fi