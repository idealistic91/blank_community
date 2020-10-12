web: bundle exec puma -t 5:5 -p ${PORT} -e ${RAILS_ENV:-development}
worker: rails r lib/discord/bot_run.rb