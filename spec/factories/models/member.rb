FactoryBot.define do
    factory :member do
        name { Faker::Name.first_name }
        nickname { Faker::Internet.username }

        trait :linked_community do
          association :community, factory: :community
        end

        factory :membership_to_community, traits: [:linked_community]
    end
end