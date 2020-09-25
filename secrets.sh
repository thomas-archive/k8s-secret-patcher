#!/bin/bash

file=${1:-file}
secret_data=${2:-secret}
namespace=${3:-default}

if [ -f $file ]; then

  lastline=$(tail -n 1 $file; echo x); lastline=${lastline%x}
  if [ "${lastline: -1}" != $'\n' ]; then
    echo >> $file
  fi

  get_secret() {
    VAR=$(grep $1 $file | xargs)

    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
  }

  get_name() {
    VAR=$(grep $1 $file | xargs)

    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[0]}
  }

  while read secret; do
    echo "setting secret '$(get_name $secret)'..."
    kubectl patch secret $secret_data -n $namespace -p '{"data": {"'$(get_name $secret)'": "'$(get_secret $secret | base64)'"}}' 
  done < $file

  exit 0
else
  echo "File '$file' not found!"
  exit 1
fi