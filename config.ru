# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
Discord::EventHandler.run
run Rails.application
