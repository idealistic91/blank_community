FactoryBot.define do
    factory :community do
       name { Faker::Lorem.word }
       description { Faker::Lorem.sentence }
       server_id { "764050414542389251" }
       association :creator, factory: :user_with_fix_dc_id
    end
end