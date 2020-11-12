FactoryBot.define do
    factory :user do
        email {Faker::Internet.email}
        password {Faker::Internet.password}
        discord_id { Faker::Number.number(digits: 10) }

        trait :with_discord_id do
            discord_id { '25681874' }
        end
        factory :user_with_fix_dc_id, traits: [:with_discord_id]
    end
end