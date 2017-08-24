#!/bin/bash
set -e

if [ ! -n "$COPL_POSTGRES_PASSWORD"  ] || [ ! -n "$COPL_POSTGRES_USER" ] || [ ! -n "$SECRET_KEY_BASE" ]
then
  echo "Please set COPL_POSTGRES_USER, COPL_POSTGRES_PASSWORD and SECRET_KEY_BASE"
  exit 1;
fi

BASE='docker-compose -f docker-compose-prod.yml'

function dockerrake {
  $BASE exec web bash -c "RAILS_ENV=production rake db:$1"
}

$BASE build
$BASE up -d

# provision database if first param == setupdb
if [ "$1" == "setupdb" ]
then
  dockerrake create
  dockerrake migrate
  dockerrake seed
fi
