FactoryBot.define do
    factory :community do
       name { Faker::Lorem.word }
       description { Faker::Lorem.sentence }
       server_id { "764050414542389251" }
       creator { FactoryBot.create(:user_with_discord_id) }
    end
end