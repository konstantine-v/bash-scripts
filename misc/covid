#!/bin/bash

# Prerequisites
# jq - for json parsing

# Specify country in the `-c` flag
while getopts c: option
do
case "${option}"
in
c) COUNTRY=${OPTARG};;
esac
done

# If no flag is specified then default to "USA"
if [[ -z "$COUNTRY" ]]; then
COUNTRY="USA"
fi

# Prompts user what they'd like to do. Also saves json data to cache so use can do as they please.
read -r -p "Download the latest Covid-19 news? [y/N] " response
[[ ! -e "~/.cache/covid-json" ]] && touch ~/.cache/covid-json
case "$response" in
[yY][eE][sS]|[yY])
curl https://corona.lmao.ninja/v2/countries/$COUNTRY > ~/.cache/covid-json ;;
*) ;;
esac

# Parse JSON and create variables
# Sets the json data to .cache/covid-json
C19_CASES=`cat ~/.cache/covid-json|jq '.cases'`
C19_CASES_TODAY=`cat ~/.cache/covid-json|jq '.todayCases'`
C19_DEATHS=`cat ~/.cache/covid-json|jq '.deaths'`
C19_RECOVERED=`cat ~/.cache/covid-json|jq '.recovered'`
C19_COUNTRY=`cat ~/.cache/covid-json|jq '.country'`

# Writes the formatted data to .cache/corona_stats
echo -e "The Status of COVID-19\nCountry:\t$C19_COUNTRY\n😷Cases:\t$C19_CASES\n😷Cases Today:\t$C19_CASES_TODAY\n💀Deaths:\t$C19_DEATHS\n😀Recovered:\t$C19_RECOVERED" > ~/.cache/covid_stats

echo "Done... View stats at ~/.cache/covid_stats"
