class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :has_right?

  # GET /communities
  # GET /communities.json
  def index
    @communities = Community.all
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
  end

  # GET /communities/new
  def new
    @community = Community.new
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

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.find_by(id: params[:id])
    unless @community
      flash[:error] = "Community was not found!"
      redirect_back(fallback_location: root_path) and return
    end
  end

  def has_right?
    has_right = current_user == @community.creator
    unless has_right
      flash[:error] = "Action not permitted!"
      redirect_back(fallback_location: root_path) and return
    end
  end
    # Only allow a list of trusted parameters through.
  def community_params
    params.fetch(:community, {})
  end
end
