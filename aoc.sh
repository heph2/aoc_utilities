#!/bin/sh
# Advent Of Code Utility
#     Copyright (C) 2021  Heph
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU Affero General Public License as
#     published by the Free Software Foundation, either version 3 of the
#     License, or (at your option) any later version.
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU Affero General Public License for more details.
#     You should have received a copy of the GNU Affero General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -e

Help()
{
   echo "Simple shell script for download AoC input."
   echo
   echo "Syntax: aoc [-y|-d|-h] <options>"
   echo "options:"
   echo "y     Year of AoC."
   echo "d     Day of input."
   echo "i     Download input of selected year and day."
   echo "s     Submit answer."
   echo "r     Read text."
   echo "c     Print Private Leaderboard chart."
   echo "h     Print this Help."
}

Read()
{
    response=$(curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/$2/day/$1")
    echo $response | sed -n 's:.*<main>\(.*\)</main>.*:\1:p' | html2text
}

Chart()
{
    chart=$(curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/2021/leaderboard/private/view/$1.json")

    echo $chart | jq -r '.members[]' |jq -s -c 'sort_by(.local_score) | reverse' | jq -r '.[] | [.stars, .local_score, .name] | @csv' | awk -v FS="," 'BEGIN{print "STARS\tSCORE\t\tNAME";print "================================="}{printf "%d\t%d\t\t%s%s", $1, $2, $3, ORS}'    
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
    
    response=$(curl --fail -sS -d "level=$part&answer=$answer" -H "$content_type" -b "$COOKIE_AOC" -X POST "https://adventofcode.com/$2/day/$1/answer")

    echo $response | sed -n 's:.*<main>\(.*\)</main>.*:\1:p' | fmt | html2text
}

while getopts :hy:d:c:isr flag
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
        c) Chart ${OPTARG}
           exit;;
        \?) echo "Error: Invalid Option"
            exit;;
    esac
done
