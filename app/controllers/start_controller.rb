class StartController < ApplicationController
    layout 'application_vue'

    skip_before_action :authenticate_user!, :current_community, :only => [:index]

    def index
        @user = current_user
        @logged_in = current_user.present?
        # Add these to a config html rel and parse it to vue app
        # Entry for vue app        
    end
end
  