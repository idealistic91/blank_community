#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails db:migrate
bundle exec puma --threads 5:5 \
  --bind tcp://0.0.0.0:${PORT:-3000} \
  --environment ${RAILS_ENV:-production}