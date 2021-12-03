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

help()
{
   echo "Simple shell script for download AoC input."
   echo
   echo "USAGE:"
   echo       "aoc.sh [OPTIONS] <COMMAND>"
   echo
   echo "FLAGS:"
   echo       "-h"
   echo               "Prints help information"
   echo
   echo "OPTIONS:"
   echo       "-d"
   echo               "Puzzle Day"
   echo       "-y"
   echo               "Puzzle Year"
   echo       "-c"
   echo               "Chart of Private Leaderboard"   
   echo
   echo "ARGS:"
   echo       "-i"
   echo               "Download Input of selected year and day"
   echo       "-r"
   echo               "Read the Puzzle of the selected year and day"
   echo       "-s"
   echo               "Submit the Answer for the selected year and day"   
}

read_puzzle()
{
    curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/$2/day/$1" | sed -n '/<main>/,/<\/main>/p' | html2text
}

chart()
{
    chart=$(curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/2021/leaderboard/private/view/$1.json")

    echo $chart | jq -r '.members[]' | \
        jq -s -c 'sort_by(.local_score) | reverse' | \
        jq -r '.[] | [.stars, .local_score, .name] | @csv' | \
        awk -v FS="," 'BEGIN{print "STARS\tSCORE\t\tNAME";print "================================="}{printf "%d\t%d\t\t%s%s", $1, $2, $3, ORS}'    
}

input()
{
    mkdir -p day_$1
    output_path="day_$1/input.txt"

    [ -f "$output_path" ] && {
	      echo already loaded
	      exit
    } >&2

    curl --fail -sS -b "$COOKIE_AOC" "https://adventofcode.com/$2/day/$1/input" -o "$output_path"
}

submit()
{
    echo "Which part you want submit?"
    read -r part

    echo "Write down the solution"
    read -r answer
    
    content_type="Content-Type: application/x-www-form-urlencoded"
    
    response=$(curl -d "level=$part&answer=$answer" -H "$content_type" -b "$COOKIE_AOC" -X POST "https://adventofcode.com/$2/day/$1/answer")

    echo $response | sed -n '/<main>/,/<\/main>/p' | fmt | html2text
}

while getopts hy:d:c:isr flag
do
    case "$flag" in
        h) mode="help";;
        i) mode="input";;
        s) mode="submit";;
        r) mode="read_puzzle";;
        c) mode="chart" ; leaderboard="${OPTARG}";;
        y) year="${OPTARG}";;
        d) day="${OPTARG}";;
        \*) echo "Missing Mode"
            exit;;
    esac

    if [ "$mode" = "input" -o  "$mode" = "submit" -o "$mode" = "read" ];
    then
        if [ -z "$year" -a -z "$day" ];
        then
            echo "Year and Day are not defined."
            exit;
        fi
    fi

    case "$mode" in
        help) help
              exit;;
        input) input "$day" "$year"
               exit;;
        read_puzzle) read_puzzle "$day" "$year"
               exit;;
        submit) submit "$day" "$year"
                exit;;
        chart) chart "$leaderboard"
               exit;;
    esac
done
