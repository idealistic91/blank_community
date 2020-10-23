require 'rails_helper'
RSpec.describe User, type: :model do
  before do
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
  describe 'instance methods' do
    let(:user) { FactoryBot.create(:user, discord_id: '25681874') }
    let(:event) do
      event = FactoryBot.create(:event)
      event.hosting_events << HostingEvent.create(event_id: event.id, member_id: user.member.id)
      event.save
      event
    end

    context 'create_member' do
        it 'it creates and links a member record' do
          expect(user.member.blank?).to eq(false)
        end
    end
    context 'do_i_participate?' do
      it 'returns true if user is part of the events participants' do
        expect(user.do_i_participate?(event)).to eq(true)
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
