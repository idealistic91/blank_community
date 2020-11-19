require 'rails_helper'
RSpec.describe User, type: :model do
  before do
    dc_api_stub = DiscordApiStub.new(server_id: "764050414542389251",
                                     members: %w[25681874 5345345 5736458743],
                                     roles: %w[admin members family])
    dc_api_stub.stub
  end

  describe 'instance methods' do
    let(:user) { FactoryBot.create(:user_hosting_an_event, discord_id: '5345345') }
    context 'do_i_participate?' do
      it 'returns true if user is part of the events participants' do
        expect(user.do_i_participate?(event)).to eq(true)
        #expect(user2.do_i_participate?(event)).to eq(false)
      end
    end

    context 'am_i_hosting?' do
      it 'returns true if user is a host' do
        expect(user.am_i_hosting?(event)).to eq(true)
      end
    end
  end

  describe 'validations' do
    context 'standard validations' do
      it { is_expected.to validate_uniqueness_of(:discord_id) }
    end
    context 'custom validations' do
      let(:valid_user) { FactoryBot.create(:user, discord_id: '25681874') }
      let(:invalid_discord_id) { FactoryBot.build(:user) }
      let(:missing_discord_id) { FactoryBot.build(:user, discord_id: '') }
      it 'validates the presence of discord_id on the given server' do
        expect(valid_user.valid?).to eq(true)
        expect(invalid_discord_id.valid?).to eq(false)
        expect(invalid_discord_id.errors.full_messages.first).to eq('Discord Du bist kein Mitglied des Discord Servers!')
      end
      it 'validates presence of discord_id' do
        expect(missing_discord_id.valid?).to eq(false)
      end
    end
  end
end
