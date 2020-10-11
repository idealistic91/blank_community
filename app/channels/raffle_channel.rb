class RaffleChannel < ApplicationCable::Channel
  require 'json'
  #before_subscribe :find_raffle_by_uuid

  def subscribed
    @raffle = Raffle.find_by(view_uuid: params[:view_uuid])
    if @raffle
      stream_from "raffle_#{@raffle.view_uuid}"
    else
      reject
      #connection.transmit identifier: params, error: "The Raffle could not be found"
    end
  end

  def receive(data)
    position = Position.new(latitude: data['lat'], longitude: data['lng'])
    # Client sends their own coordinates to every other client subscribed in the channel
    # Later we will receive geojson data from frontend and send geojson back
    if Rails.env.development?
      data = GeoMethods.random_coordinates(data['lat'], data['lng'], km: 3)
    end
    ActionCable.server.broadcast("raffle_#{params[:view_uuid]}", {
        lat: data['lat'],
        lng: data['lng']
    }.to_json)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
