#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(sum_of_goals) FROM (SELECT SUM(winner_goals + opponent_goals) AS sum_of_goals FROM games GROUP BY game_id) as subquery")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id = (SELECT winner_id FROM games WHERE round LIKE 'Final' AND year = 2018)")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams LEFT JOIN (SELECT winner_id FROM games WHERE round LIKE 'Eighth-Final' AND year = 2014) AS f1 on teams.team_id = f1.winner_id LEFT JOIN (SELECT opponent_id FROM games WHERE round LIKE 'Eighth-Final' AND year = 2014) AS f2 ON teams.team_id = f2.opponent_id WHERE f1.winner_id IS NOT NULL OR f2.opponent_id IS NOT NULL ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT name FROM teams FULL JOIN (SELECT winner_id, COUNT(winner_id) FROM teams INNER JOIN games ON teams.team_id = games.winner_id GROUP BY games.winner_id) AS foo on teams.team_id = foo.winner_id WHERE winner_id IS NOT NULL ORDER BY name;")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM teams INNER JOIN games ON teams.team_id = games.winner_id WHERE round LIKE 'Final' ORDER BY year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON teams.team_id = games.winner_id WHERE name LIKE 'Co%'")"

