#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
# Reading each line

#JUMP IF FIRST ROW
if [ $year != 'year' ]; then

  #SELECT WINNER TEAM IF EXISTS IN TABLE
  TEAM_WINNER=$($PSQL "SELECT name FROM teams WHERE name LIKE '$winner';")
  
  #IF IT DOES, DO NOTHING
  if [[ -z ${TEAM_WINNER} ]]; then
    #INSERT WINNER TEAM ON TEAMS
    INSERT_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$winner');")
  fi

  #SELECT LOSER TEAM IF EXISTS IN TABLE  
  TEAM_LOSER=$($PSQL "SELECT name FROM teams WHERE name LIKE '$opponent';")
  #IF IT DOES, DO NOTHING
  if [[ -z ${TEAM_LOSER} ]]; then
   #INSERT LOSER TEAM ON TEAMS
   INSERT_LOSE=$($PSQL "INSERT INTO teams(name) VALUES('$opponent');")
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$winner'")
  LOSER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$opponent'")
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$year', '$round', '$WINNER_ID', '$LOSER_ID', '$winner_goals', '$opponent_goals')")
fi
done < games.csv
