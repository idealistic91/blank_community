module API
    module V1
      class Events < Grape::API
        include API::V1::Defaults
            resource :events do
                desc 'Returns event by id'
                params do
                    requires :id, type: String, desc: "ID of the event"
                end
                get ':id' do
                    event = Event.where(id: permitted_params[:id]).first!
                end
            end
        end
    end
end