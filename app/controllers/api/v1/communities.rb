module API
    module V1
      class Communities < Grape::API
        include API::V1::Defaults
        resource :communities do
            desc "Returns communities where I have a membership"
            get "/my_communities" do
                current_user.memberships.includes(:community).map(&:community)
            end

            desc "All communities"
            get "" do
                Community.all
            end

            desc 'Community by id'
            params do
                requires :id, type: String, desc: "ID of the community"
            end
            get ':id' do
                Community.where(id: permitted_params[:id]).first!
            end

            desc 'Memberships of community'
            params do
                requires :id, type: String, desc: "ID of the community"
            end
            get '/:id/memberships' do
                community = Community.where(id: permitted_params[:id]).first!
                community.members
            end

            desc 'Events of communities'
            params do
                requires :id, type: String, desc: "ID of the community"
                requires :scope, type: String, values: ['upcoming_events', 'past_events', 'live_events'], desc: "Type of Events"
            end
            get '/:id/events' do
                community = Community.where(id: permitted_params[:id]).first!
                community.events.send(permitted_params[:scope]).includes(:games, members: [:user], hosts: [:user])
            end
        end
    end
  end
end