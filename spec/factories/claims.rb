FactoryGirl.define do
  factory :claim do
    member
    listing

    name            { Faker::Name.first_name }
    email           { Faker::Internet.free_email(name) }
    phone           { Faker::PhoneNumber.phone_number }

    approved        nil

    trait :approved do
      approved      'yes'
    end

    trait :disapproved do
      approved      'no'
    end
  end
end
