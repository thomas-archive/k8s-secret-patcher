#!/bin/bash

secret_data=${1:-secret}
namespace=${2:-default}

if [ -f .env ]; then

  lastline=$(tail -n 1 .env; echo x); lastline=${lastline%x}
  if [ "${lastline: -1}" != $'\n' ]; then
    echo >> .env
  fi

  get_secret() {
    VAR=$(grep $1 .env | xargs)

    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
  }

  get_name() {
    VAR=$(grep $1 .env | xargs)

    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[0]}
  }

  while read secret; do
    echo "setting secret '$(get_name $secret)'..."
    kubectl patch secret $secret_data -n $namespace -p '{"data": {"'$(get_name $secret)'": "'$(get_secret $secret | base64)'"}}' 
  done < .env

  exit 0
else
  echo "No .env file found!"
  exit 1
fi