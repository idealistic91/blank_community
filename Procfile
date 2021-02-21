release: bin/rails db:migrate
web: bundle exec puma -t 5:5 -p ${PORT} -e ${RAILS_ENV:-development}
worker: bundle exec sidekiq
bot1: SHARD=1 bin/rake start_bot