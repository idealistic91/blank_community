FactoryBot.define do
    factory :member do
        name { Faker::Name.first_name }
        nickname { Faker::Internet.username }
        association :user, factory: :user
    end
end