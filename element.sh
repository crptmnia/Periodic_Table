#!/bin/bash

# If argument is empty
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Query database and store in a variable
ELEMENT=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -c \
        "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
        FROM elements e
        INNER JOIN properties p USING(atomic_number)
        INNER JOIN types t ON p.type_id = t.type_id
        WHERE e.atomic_number::text='$1' OR e.symbol='$1' OR e.name='$1';")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$ELEMENT"
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
