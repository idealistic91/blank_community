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

        trait :hosting_an_event do
          after(:create) do |user|
            event = FactoryBot.create(:event, community_id: user.memberships.first.community.id)
            event.save
            event.add_host(user.memberships.first.id)
            event.host_join_event
          end
        end

        factory :user_with_discord_id, traits: [:with_discord_id]
        factory :user_with_membership, traits: [:with_membership]
        factory :user_hosting_an_event, traits: [:with_membership, :hosting_an_event]
    end
end