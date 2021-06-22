module API
    module V1
      class Users < Grape::API
        include API::V1::Defaults
        resource :users do
          desc "Return all users"
            get "" do
              User.all
            end
          desc "Return a user"
            params do
              requires :id, type: String, desc: "ID of the user"
            end
            get ":id" do
              User.where(id: permitted_params[:id]).first!
            end
          desc 'users communities'
            params do
              requires :id, type: String, desc: "ID of the user"
            end
            get "/:id/communities" do
              user = User.where(id: permitted_params[:id]).first!
              user.memberships.includes(:community).map(&:community)
            end
        end
      end
    end
  end