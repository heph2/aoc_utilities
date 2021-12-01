#!/bin/sh

set -e

Help()
{
   echo "Simple shell script for download AoC input."
   echo
   echo "Syntax: aoc [-y|-d|-h]"
   echo "options:"
   echo "y     Year of AoC."
   echo "d     Day of input."
   echo "i     Download input of selected year and day."
   echo "s     Submit answer."
   echo "r     Read text."
   echo "h     Print this Help."
}

Read()
{
    response=$(curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/$2/day/$1")
    echo $response | sed -n 's:.*<main>\(.*\)</main>.*:\1:p' | html2text
}

Input()
{
    mkdir -p day_$1
    output_path="day_$1/input.txt"

    [ -f "$output_path" ] && {
	      echo already loaded
	      exit
    } >&2

    curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/$2/day/$1/input" -o "$output_path"
}

Submit()
{
    echo "Which part you want submit?"
    read -r part

    echo "Write down the solution"
    read -r answer
    
    content_type="Content-Type: application/x-www-form-urlencoded"
    
    response=$(curl -d "level=$part&answer=$answer" -H "$content_type" -b "$COOKIE_AOC" -X POST "https://adventofcode.com/$2/day/$1/answer")

    echo $response | sed -n 's:.*<main>\(.*\)</main>.*:\1:p' | fmt | html2text
}

while getopts :hy:d:isr flag
do
    case "$flag" in
        h) Help
           exit;;
        y) year=${OPTARG};;
        d) day=${OPTARG};;
        i) Input $day $year
           exit;;
        s) Submit $day $year
           exit;;
        r) Read $day $year
           exit;;
        \?) echo "Error: Invalid Option"
            exit;;
    esac
done
