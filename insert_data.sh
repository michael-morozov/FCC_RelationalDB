#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
# read 

#$PSQL "INSERT INTO games (year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES ($YEAR, '$ROUND', $WGOALS, $OGOALS, 0,0)"

#Inserting data to teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != "year" ]]
    then 
    WINNER_ID_CHECK=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    echo $WINNER_ID_CHECK $WINNER
    if [[ -z $WINNER_ID_CHECK ]]
      then
      $PSQL "INSERT INTO teams (name) VALUES ('$WINNER')"
    fi
    OPP_ID_CHECK=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    echo $OPP_ID_CHECK $OPPONENT
    if [[ -z $OPP_ID_CHECK ]]
      then
      $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')"
    fi
  fi
done

#Inserting data to games table

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != "year" ]]
    then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    $PSQL "INSERT INTO games (year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES ($YEAR, '$ROUND', $WGOALS, $OGOALS, $WINNER_ID,$OPPONENT_ID)"
  fi
done
