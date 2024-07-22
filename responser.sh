#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

filename="$1"

while read -r LINE; do
  response_code=$(curl -o /dev/null --silent --head --write-out "%{http_code}" "$LINE")
  if [[ "$response_code" == "200" || "$response_code" == "302" ]]; then
    echo "$response_code $LINE"
  elif [[ "$response_code" == "000" ]]; then
    secure_response_code=$(curl -o /dev/null --silent --head --write-out "%{http_code}" -k "$LINE")
    if [[ "$secure_response_code" == "200" || "$secure_response_code" == "302" ]]; then
      echo "$secure_response_code $LINE"
    fi
  fi
done < "$filename"