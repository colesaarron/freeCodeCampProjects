#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Add each unique team to teams table (24 rows)

# Insert a row for each line in games.csv (32 rows)

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # Fill the teams table
    # check if team is already stored
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    # if empty, insert the team
    if [[ -z $WINNER_ID ]]
    then 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    # get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    # check if already exists
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")   
    # if empty, insert into table
    if [[ -z $OPPONENT_ID ]]
    then 
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    # Fill the games table
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = '$YEAR' AND round = '$ROUND' AND winner_id = $WINNER_ID AND opponent_id = $OPPONENT_ID")
    if [[ -z $GAME_ID ]]
    then 
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi


  fi

  # echo "Year:";
  # echo "$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
    # echo "$YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS"
    # INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$WINNER', $OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")

done 

# cat games.csv