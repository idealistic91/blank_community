require 'rails_helper'
RSpec.describe Member, type: :model do
    before do
        community = DiscordApiStub.new(server_id: "764050414542389251",
                                         members: %w[25681874 453534],
                                         roles: %w[admin members family])
        community.stub
    end
    let!(:community) { create(:community) }
    let(:owner) { community.creator }
    let(:user) { create(:user, discord_id: '453534') }
    let(:member) { user.memberships.first }
    describe 'class methods' do
        context 'create_for_owner' do
            it 'creates a membership for the community creator' do
                owner.membership_by_community(community.id).first.destroy
                membership = described_class.create_for_owner(community)
                expect(owner.memberships.include?(membership)).to eq(true)
            end
        end
    end

    describe 'instance methods' do
        context 'discord_user' do
            it 'creates an instance of Discordrb::User' do
                expect(member.discord_user.class).to eq(Discordrb::User)
            end
        end
        context 'discord_avatar' do
            it 'gets profile picture url from discord' do
                url = member.discord_avatar
                is_like = "https://cdn.discordapp.com/avatars/#{member.user.discord_id}/#{member.discord_user.avatar_id}.png"
                expect(url).to eq(is_like)
            end
        end
    end
end
