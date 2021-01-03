require 'rails_helper'

RSpec.describe Event, type: :model do
  before do
    dc_api_stub = DiscordApiStub.new(server_id: "34244235",
                                     members: %w[25681874 6535345 43243],
                                     roles: %w[admin members family])
    dc_api_stub.stub
  end
  let(:community) { FactoryBot.create(:community, server_id: '34244235') }
  let(:user) do
    community 
    FactoryBot.create(:user_hosting_an_event, discord_id: '6535345')
  end
  let(:user_event) do 
    user
    community.events.first
  end

  describe 'instance methods' do
    let(:event) { FactoryBot.create(:event_with_game, community: community)}
    let(:event_without_game) { FactoryBot.create(:event, community: community)}
    let(:membership1) { user.memberships.first }
    let(:user2) { FactoryBot.create(:user, discord_id: '43243') }
    let(:membership2) { user2.memberships.first }
    
    context 'game_name' do
      it 'returns a game name if event has a game attached' do
        expect(event.game_name).to eq(event.game.name)
        expect(event_without_game.game_name).to eq(nil)
      end
    end

    context 'hosts' do
      it 'returns all hosts' do
        expect(user_event.hosts.include?(membership1)).to eq(true)
        expect(user_event.hosts.include?(membership2)).to eq(false)
      end
    end

    context 'add_host' do
      it 'adds a new host to the event' do
        expect(user_event.hosts.include?(membership2)).to eq(false)
        user_event.add_host(membership2.id)
        # Is now a host & participant
        expect(user_event.hosts.include?(membership2)).to eq(true)
        expect(user_event.members.include?(membership2)).to eq(true)
      end
    end
  end
end
