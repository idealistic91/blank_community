# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :html, :json

  # before_action :configure_sign_in_params, only: [:create]
  after_action :create_cookies, :create_igdb_base, only: :create

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        resource = User.find_for_database_authentication(email: params[:user][:email])
        return invalid_login_attempt unless resource
    
        if resource.valid_password?(params[:user][:password])
          sign_in :user, resource
          render json: { success: true, user: resource }, status: 200 and return
        end
    
        invalid_login_attempt
      }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end
  
  protected

  def invalid_login_attempt
    set_flash_message(:alert, :invalid)
    render json: flash[:alert], status: 401
  end
  
  def create_cookies
    cookies.signed[:communities] = {
      :value => user_communities_roles,
      :secure => !(Rails.env.test? || Rails.env.development?)
    }
    if cookies.signed[:active_community].nil? || current_user.membership_by_community(cookies.signed[:active_community]).empty?
      cookies.signed[:active_community] = {
        :value => current_user.memberships.map{ |m| m.community.id }.last,
        :secure => !(Rails.env.test? || Rails.env.development?)
      }
    end
  end

  def user_communities_roles
    current_user.memberships.map do |membership|
      { 
        id: membership.community.id,
        roles: membership.roles.map(&:key)
      }
    end
  end

  def create_igdb_base
    $igdb_base = IGDB::Base.new
  end
end
