module API
    module V1
      class Memberships < Grape::API
        include API::V1::Defaults
        resource :memberships do
            desc "Returns users memberships"
            get "/my_memberships" do
                current_user.memberships
            end
        end
      end
    end
  end