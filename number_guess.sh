#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
#echo "Enter your username:"
read USERNAME
U_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
if [[ -z $U_ID ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  #echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  U_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  GAME_COUNT=$($PSQL "SELECT count(user_id) FROM game WHERE user_id = $U_ID")
  BEST_GUESS=$($PSQL "SELECT min(guess) FROM game WHERE user_id = $U_ID")
  echo -e "\nWelcome back, $USERNAME! You have played $GAME_COUNT games, and your best game took $BEST_GUESS guesses."
  #echo "Welcome back, $USERNAME! You have played $GAME_COUNT games, and your best game took $BEST_GUESS guesses."
fi

NUMBER=$(($RANDOM%(1000)+1))
#echo $NUMBER
echo -e "\nGuess the secret number between 1 and 1000:"
ATTEMPTS=0
GUESS=1001
while [[ $GUESS != $NUMBER ]]
do
  read GUESS
  ATTEMPTS=$(($ATTEMPTS+1))
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
    #echo "That is not an integer, guess again:"
  elif [[ $NUMBER -gt $GUESS ]]
  then
    #echo -e "\nIt's higher than that, guess again:"
    echo "It's higher than that, guess again:"
  elif [[ $NUMBER -lt $GUESS ]]
  then
    #echo -e "\nIt's lower than that, guess again:"
    echo "It's lower than that, guess again:"
  fi
done
echo -e "\nYou guessed it in $ATTEMPTS tries. The secret number was $NUMBER. Nice job!"
#echo "You guessed it in $ATTEMPTS tries. The secret number was $NUMBER. Nice job!"
UPDATE_DATA=$($PSQL "INSERT INTO game VALUES($U_ID, $ATTEMPTS)")
