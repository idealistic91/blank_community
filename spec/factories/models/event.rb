FactoryBot.define do
  factory :event do
    title { Faker::Game.title }
    date { rand(1..20).days.from_now }
    description { Faker::Lorem.sentence }
    slots { rand(3..20) }   
    association :game, factory: :game

    before(:create) do |event|
      event.start_at = event.date.to_datetime.change(hour: rand(1..23), min: 30)
      event.ends_at = event.start_at + rand(1..5).hours
      event.save
    end
  end
end