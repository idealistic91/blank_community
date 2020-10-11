worker: bundle exec rails r lib/discord/bot_run.rb -e ${RAILS_ENV}
web: bundle exec puma -t 5:5 -p ${PORT} -e ${RAILS_ENV:-development}