release: bin/rails db:migrate
web: bundle exec puma -t 5:5 -p ${PORT} -e ${RAILS_ENV:-development}
worker: rails r Discord::EventHandler.run
worker: bundle exec sidekiq