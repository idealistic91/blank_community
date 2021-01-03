require 'rails_helper'

RSpec.describe Community, type: :model do
  before do
    community = DiscordApiStub.new(server_id: "764050414542389251",
      members: %w[25681874 453534],
      roles: %w[admin members family])
    community.stub
  end
  
  let(:community) { FactoryBot.create(:community) }
  let(:creator) { community.creator }

  describe 'callbacks' do
    context 'after_create - create_discord_roles' do
      it 'creates discord_roles from server roles' do
        roles = community.server.roles
        roles.each do |role|
          expect(DiscordRole.find_by(name: role['name']).nil?).to eq(false)
        end
      end
    end
    
    context 'create_owner_member' do
      it 'creates a membership for the community owner/creator' do
        expect(creator.memberships.size).to eq(1)
        expect(creator.memberships.first.community).to eq(community)
      end
    end
  end

  describe 'instance methods' do
    context 'server' do
      it 'creates a new instance of Discord::Server' do
        expect(community.server.class).to eq(Discord::Server)
      end
    end
  end
end
