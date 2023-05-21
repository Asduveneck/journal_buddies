# Journal Buddies

## Local setup

This project requires docker compose, and to initialize the database:

```sh
docker compose run web bin/rails db:create
docker compose run web bin/rails db:migrate
```

Afterwards, starting the backend is as simple as

```sh
docker compose up
```

RSpec tests can be run via

```sh
docker compose run web bundle exec rspec $OPTIONAL_FILE_PATH
```

Some useful snippets to abbreviate these commands are located within [bin/run_docker_shortcuts.sh](bin/run_docker_shortcuts.sh). 