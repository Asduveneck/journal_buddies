#!/bin/bash

if [ -z "$1" ]; then
  echo "Please type in a valid command:"
  read COMMAND
else
  COMMAND=$1
fi

shift

case $COMMAND in
  rails-g-migration | r-g-m )
    docker compose run web bin/rails generate migration "$@"
  ;;

  rails-g-serializer | r-g-s )
    docker compose run web bin/rails generate serializer "$@"
  ;;

  rails-run-migration | rails-db-migrate | r-db-m )
    docker compose run web bin/rails db:migrate "$@"
  ;;

  rails-console | rails-c | r-c )
    docker compose run --rm web bin/rails console
  ;;

  rspec )
    docker compose run web bundle exec rspec "$@"
  ;;

  rails-init-test-db )
    docker compose run web bin/rails db:create
  ;;

  * )
    echo "Invalid command"
  ;;
esac
