FactoryGirl.define do
  factory :rating do
    listing

    title         { Faker::Lorem.sentence(2, true, 4)[0...100] }
    body          { Faker::Lorem.paragraph(3, true, 4) }
    score         4
    initials      'ADA'
    approval      true
    attended      true

    trait :pending do
      approval    nil
    end

    trait :disapproved do
      approval    false
    end
  end
end
