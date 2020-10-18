FactoryBot.define do
    factory :user do
        email {Faker::Internet.email}
        password {Faker::Internet.password}
        discord_id { Faker::Number.number(digits: 10) }
    end
end