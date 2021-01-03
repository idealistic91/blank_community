require 'rails_helper'
RSpec.describe User, type: :model do
  before do
    dc_api_stub = DiscordApiStub.new(server_id: "764050414542389251",
                                     members: %w[25681874 5345345 5736458743 33115812],
                                     roles: %w[admin members family])
    dc_api_stub.stub
  end

  describe 'instance methods' do
    let!(:community) { FactoryBot.create(:community) }
    let(:user) do 
      FactoryBot.create(:user_hosting_an_event, discord_id: '5345345') 
    end
    let(:user2) { FactoryBot.create(:user, discord_id: '33115812') }
    let(:event) { user.memberships.first.hosting_events.map(&:event).first }
    
    context 'do_i_participate?' do
      it 'returns true if user is part of the events participants' do
        expect(user.do_i_participate?(event)).to eq(true)
        expect(user2.do_i_participate?(event)).to eq(false)
      end
    end

    context 'am_i_hosting?' do
      it 'returns true if user is a host' do
        expect(user.am_i_hosting?(event)).to eq(true)
        expect(user2.am_i_hosting?(event)).to eq(false)
      end
    end
    
    context 'membership_by_community' do
      it 'returns the membership of given community id' do
        membership = user.membership_by_community(community.id)
        expect(membership.first.class).to eq(Member)
        expect(membership.first.community).to eq(community)
      end
    end
  end

  describe 'validations' do
    context 'standard validations' do
      it { is_expected.to validate_uniqueness_of(:discord_id) }
    end
    context 'custom validations' do
      let(:valid_user) { FactoryBot.create(:user, discord_id: '25681874') }
      let(:missing_discord_id) { FactoryBot.build(:user, discord_id: '') }
      
      it 'validates the presence of discord_id' do
        expect(valid_user.valid?).to eq(true)
      end
      
      it 'validates presence of discord_id' do
        expect(missing_discord_id.valid?).to eq(false)
      end
    end
  end
end
