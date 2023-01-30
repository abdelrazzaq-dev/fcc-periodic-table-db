PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL"SELECT * FROM elements WHERE atomic_number = $1")
  else
    ELEMENT=$($PSQL"SELECT * FROM elements WHERE name = '$1' OR symbol = '$1'")
  fi
  
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo $ELEMENT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
      ELEMENT_PROPERTIE=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      echo $ELEMENT_PROPERTIE | while read ATOMIC_NUMBER BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE_ID
      do
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    done
  fi
fi
