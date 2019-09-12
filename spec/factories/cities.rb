FactoryGirl.define do
  factory :city do
    state
    name          { Faker::Address.city }
    latitude      { Faker::Address.latitude }
    longitude     { Faker::Address.longitude }
  end
end
