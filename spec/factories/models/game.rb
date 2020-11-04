FactoryBot.define do
  factory :game do
    name { Faker::Game.title }
    description { Faker::Lorem.paragraph }
    title_picture { FilesTestHelper.jpg }
  end
end