# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :check_community, only: :create
  after_action :create_community, only: :create

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def check_community
    if params[:server_id]
      server = Discord::Server.new(id: params[:server_id])
      begin
        @info = server.info
        @community = Community.new(name: @info['name'], server_id: @info['id'])
        unless @community.save
          flash[:error] = "Fehler: #{@community.errors.full_messages.join(', ')}"
          render :new and return
        end
      rescue => exception
        flash[:error] = "Discord Server nicht gefunden! Exception: #{exception.message}"
        render :new and return
      end
    end
  end

  def create_community
    unless @community.nil?
      @community.reload
      @community.creator = resource
      @community.save
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
