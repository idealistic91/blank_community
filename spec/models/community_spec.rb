require 'rails_helper'

RSpec.describe Community, type: :model do
  before do
    # For user creation
    stub_all_members('25681874')
    stub_roles
    stub_avatar_request
    stub_channels
    stub_send_message
    stub_channel
    stub_guild
    stub_member
    stub_bot
  end
  
  let(:community) { FactoryBot.create(:community) }

  describe 'callbacks' do
    context 'after_create' do
      it 'creates discord_roles from server roles' do
        roles = community.server.roles
        roles.each do |role|
          expect(DiscordRole.find_by(name: role['name']).nil?).to eq(false)
        end
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
