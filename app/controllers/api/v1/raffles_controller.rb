class Api::V1::RafflesController < ActionController::API
  before_action :load_raffles, only: :index
  before_action :load_raffle, only: [:show, :join_raffle]
  before_action :load_participant, only: :join_raffle

  def index
    render json: @raffles, includes: :participants
  end

  def show
    render json: @raffle
  end

  def join_raffle
    if @raffle && @participant
      @raffle.participants << @participant
      @raffle.save
      response = { flash: 'Successfully joined the raffle', view_uuid: @raffle.view_uuid }
    else
      response = { flash: 'Raffle/Participant not found' }
    end
    # The user is now part of the raffle and gets back the view_uuid which is need to subscribe to the web socket channel
    render json: response
  end

  private

  def load_raffles
    @raffles = Raffle.all
  end

  def load_raffle
    @raffle = Raffle.find_by(id: params[:raffle_id])
  end

  def load_participant
    @participant = Participant.find_by(id: params[:participant_id])
    # Later loaded through user
    # @participant = current_user.participant
  end
end