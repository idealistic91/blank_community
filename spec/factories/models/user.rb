FactoryBot.define do
    factory :user do
        email {Faker::Internet.email}
        password {Faker::Internet.password}
        discord_id { Faker::Number.number(digits: 10) }

        trait :with_discord_id do
            discord_id { '25681874' }
        end

        trait :with_membership do
          after(:create) do |user|
            m = FactoryBot.create(:membership_to_community, user_id: user.id)
            user.memberships << m
            user.save
          end
        end
        factory :user_with_discord_id, traits: [:with_discord_id]
        factory :user_with_membership, traits: [:with_membership]
    end
end