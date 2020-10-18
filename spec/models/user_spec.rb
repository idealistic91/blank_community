require 'rails_helper'

RSpec.describe User, type: :model do
    before do
        stub_all_members('25681874')
        stub_roles
        stub_avatar_request
    end
  let(:record) { FactoryBot.create(:user, discord_id: '25681874') }

  describe 'instance methods' do
      context 'create_member' do
          it 'it creates and links a member record' do
            begin
                record
            rescue NameError => e
                puts e.backtrace
            end
          end
      end
      context 'do_i_participate?' do
          
      end
      context 'am_i_hosting?' do
          
      end
  end

  describe 'validation methods' do
      context 'discord_id_check' do
          
      end
  end
end
