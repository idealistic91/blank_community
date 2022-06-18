module API
    module V1
      module Defaults
        extend ActiveSupport::Concern
        
        included do
          prefix "api"
          version "v1", using: :path
          default_format :json
          format :json
          formatter :json, 
               Grape::Formatter::ActiveModelSerializers
  
          before do
            error!("401 Unauthorized", 401) unless authenticated
          end

          helpers do
            def permitted_params
              @permitted_params ||= declared(params, 
                 include_missing: false)
            end
  
            def logger
              Rails.logger
            end

            def warden
              env['warden']
            end
      
            def authenticated
              return true if warden.authenticated?
              params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
            end
      
            def current_user
              warden.user || @user
            end

          end
  
          rescue_from ActiveRecord::RecordNotFound do |e|
            error_response(message: e.message, status: 404)
          end
  
          rescue_from ActiveRecord::RecordInvalid do |e|
            error_response(message: e.message, status: 422)
          end
        end
      end
    end
  end