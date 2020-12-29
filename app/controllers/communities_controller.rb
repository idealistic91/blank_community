class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy, :assign_role, :unassign_role, :set_active, :join]
  before_action :check_permission
  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.all
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
  end

  # GET /communities/1/edit
  def edit
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)
    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: 'Community was successfully created.' }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: 'Community was successfully updated.' }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    @community.destroy
    respond_to do |format|
      format.html { redirect_to communities_url, notice: 'Community was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign_role
    respond_to do |format|
      format.js {
        discord_role = DiscordRole.find_by(id: params[:dc_role_id])
        discord_role.assign_role(params[:role])
        element = render_to_string partial: 'communities/partials/discord_role_list', locals: { dc_role: discord_role }, layout: false, format: :html
        render json: { element: element, dc_role_id: discord_role.id }
      }
    end
  end

  def unassign_role
    respond_to do |format|
      format.js {
        discord_role = DiscordRole.find_by(id: params[:dc_role_id])
        assignment = RoleAssignment.find_by(id: params[:assignment_id])
        assignment.destroy
        element = render_to_string partial: 'communities/partials/discord_role_list', locals: { dc_role: discord_role }, layout: false, format: :html
        render json: { element: element, dc_role_id: discord_role.id }
      }
    end
  end

  def set_active
    set_active_cookie(params[:id])
    redirect_to root_path
  end

  def join
    respond_to do |format|
      format.js {
        process = current_user.create_membership(@community)
        if process[:success]
          flash.now[:success] = "Erfolgreich beigetreten"
          render_flash_as_json
        else
          flash.now[:alert] = process[:message]
          render_flash_as_json
        end
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.find_by(id: params[:id])
    unless @community
      flash[:error] = "Community was not found!"
      redirect_back(fallback_location: root_path) and return
    end
  end

  def set_member
    @member = current_user.membership_by_community(@community.id).first
  end
    # Only allow a list of trusted parameters through.
  def community_params
    params.require(:community).permit(settings_attributes: [:public, :main_channel])
    #params.require(:community, {settings: })
  end

  def check_permission
    no_permission = false
    roles = role_hash[action_name.to_sym]
    permitted_roles = roles.detect{|role| @member.has_role?(role) }
    if permitted_roles.nil? && roles.any?
      no_permission = true
    end
    if no_permission
      flash[:alert] = "Dir fehlen Rechte für diese Aktion!"
      redirect_back fallback_location: root_path and return
    end
  end

  def role_hash
    {
        index: [],
        show: [:member, :owner, :admin],
        update: [:owner],
        destroy: [:owner],
        join: [],
        assign_role: [:owner],
        unassign_role: [:owner]
    }
  end
end
