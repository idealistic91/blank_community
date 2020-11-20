require "rails_helper"

RSpec.describe EventsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "communities/1/events").to route_to("events#index", community_id: "1")
    end

    it "routes to #new" do
      expect(get: "communities/1/events/new").to route_to("events#new", community_id: "1")
    end

    it "routes to #show" do
      expect(get: "communities/1/events/1").to route_to("events#show", id: "1", community_id: "1")
    end

    it "routes to #edit" do
      expect(get: "communities/1/events/1/edit").to route_to("events#edit", id: "1", community_id: "1")
    end


    it "routes to #create" do
      expect(post: "communities/1/events").to route_to("events#create", community_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "communities/1/events/1").to route_to("events#update", id: "1", community_id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "communities/1/events/1").to route_to("events#update", id: "1", community_id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "communities/1/events/1").to route_to("events#destroy", id: "1", community_id: "1")
    end
  end
end
