# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action :create_cookies, only: :create

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end
  
  protected
  
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
end
