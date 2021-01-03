class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :current_community, unless: :devise_controller?
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:discord_id])
  end

  def current_community
    @current_community = Community.find_by(id: cookies.signed[:active_community])
    @current_community ||= current_user.memberships.first.try(:community)
    @member = current_user.membership_by_community(@current_community.try(:id)).first
    @member ||= current_user.memberships.first
  end

  def set_active_cookie(id)
    membership = current_user.membership_by_community(id).first
    cookies.signed[:active_community] = {
      :value => membership.community.id,
      :secure => !(Rails.env.test? || Rails.env.development?)
    }
    current_community
  end

  def flash_html
    render_to_string partial: 'layouts/flash', locales: {flash: flash}, layout: false
  end

  def render_flash_as_json
    render json: { success: false, flash_box: flash_html } and return
  end
end
