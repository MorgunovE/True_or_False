#!/usr/bin/env bash

# Function to display the main menu
display_menu() {
    echo ""
    echo "0. Exit"
    echo "1. Play a game"
    echo "2. Display scores"
    echo "3. Reset scores"
    echo -n "Enter an option: "
}

# Function to play the game
play_game() {
    echo -n "What is your name? "
    read player_name

    score=0
    correct_answers=0
    responses=("Perfect!" "Awesome!" "You are a genius!" "Wow!" "Wonderful!")

    while true; do
        # Use curl to connect to the game endpoint and get a question
        game_response=$(curl --silent --cookie cookie.txt http://127.0.0.1:8000/game)
        
        # Extract question and answer from the response
        question=$(echo "$game_response" | sed 's/.*"question": *"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')
        answer=$(echo "$game_response" | sed 's/.*"answer": *"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')

        # Print the question
        echo "$question"
        echo -n "True or False? "
        read user_response

        # Check the user's response
        if [ "$user_response" == "$answer" ]; then
            score=$((score + 10))
            correct_answers=$((correct_answers + 1))
            idx=$((RANDOM % 5))
            echo "${responses[$idx]}"
        else
            echo "Wrong answer, sorry!"
            echo "$player_name you have $correct_answers correct answer(s)."
            echo "Your score is $score points."
            # Save the score to scores.txt
            echo "User: $player_name, Score: $score, Date: $(date +%Y-%m-%d)" >> scores.txt
            break
        fi
    done
}

# Function to display scores
display_scores() {
    if [ -f scores.txt ]; then
        echo "Player scores"
        cat scores.txt
    else
        echo "File not found or no scores in it!"
    end
}

# Function to reset scores
reset_scores() {
    if [ -f scores.txt ]; then
        rm scores.txt
        echo "File deleted successfully!"
    else
        echo "File not found or no scores in it!"
    fi
}

# Print the welcoming message
echo "Welcome to the True or False Game!"

# Main loop
while true; do
    display_menu
    read option

    case $option in
        0)
            echo "See you later!"
            exit 0
            ;;
        1)
            play_game
            ;;
        2)
            display_scores
            ;;
        3)
            reset_scores
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
done