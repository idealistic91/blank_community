class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy, :assign_role, :unassign_role,
       :leave, :join]
  before_action :check_permission, except: :set_active
  skip_before_action :current_community, only: :set_active
  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.public_communities
    @registered_in = current_user.memberships.map(&:community)
    @community_ids = @registered_in.map(&:id)
    @my_communities = Community.all.select{|c| c.server.get_member_by_id(current_user.discord_id) }
    @nav_items = [
        { key: :all, partial: 'communities/partials/all_communities', label: 'Alle'
        },
        { key: :registered_in, partial: 'communities/partials/registered_in', label: 'Beigetreten'
        },
        { key: :my_communities, label: 'Discord', partial: 'communities/partials/my_communities'
        }
    ]
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
        if discord_role.valid?
          flash.now[:success] = 'Rolle wurde zugewiesen'
          element = render_to_string partial: 'communities/partials/discord_role_list', locals: { dc_role: discord_role }, layout: false, format: :html
          render json: { element: element, dc_role_id: discord_role.id, flash_box: flash_html } and return
        else
          flash.now[:alert] = 'Rollenzuweisung existiert schon'
          render_flash_as_json
        end
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
        flash.now[:success] = 'Rollenzuweisung entfernt'
        render json: { element: element, dc_role_id: discord_role.id, flash_box: flash_html }
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

  def leave
    respond_to do |format|
      @member.destroy
      set_active_cookie(current_user.memberships.first.try(:id))
      format.js {
        flash.now[:success] = "Deine Mitgliedschaft wurde gelöscht!"
        render_flash_as_json
      }
    end
  end

  def fetch
    @my_communities = Community.all.select{|c| c.server.get_member_by_id(current_user.discord_id) }
    @items = []
    @memberships = current_user.memberships.map(&:community)
    @my_communities.each do |c|
      @items << (render_to_string partial: 'communities/partials/item',
                                  locals: { community: c,
                                            join: !@memberships.include?(c),
                                            scope: 'discord' })
    end
    respond_to do |format|
      format.js {
        render json: { success: true, result: @items }
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.find_by(id: params[:id])
    unless @community
      flash[:alert] = "Community was not found!"
      redirect_back(fallback_location: root_path) and return
    end
  end

    # Only allow a list of trusted parameters through.
  def community_params
    params.require(:community).permit(settings_attributes: [:public, :main_channel])
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
        set_active: [:owner, :admin, :member],
        show: [:member, :owner, :admin],
        update: [:owner],
        destroy: [:owner],
        join: [],
        leave: [:member, :admin],
        fetch: [],
        assign_role: [:owner],
        unassign_role: [:owner]
    }
  end
end
