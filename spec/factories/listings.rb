FactoryGirl.define do
  factory :listing do
    directory
    city

    listing_type  'facility'
    phone         { Faker::PhoneNumber.phone_number[0...20] }
    zipcode       { Faker::Address.zip[0...5] }

    name          { Faker::Company.name }
    address_1     { Faker::Address.street_address }

    meta_title        { name }
    meta_description  { Faker::Lorem.sentence }

    # sortname        { name.upcase }
    published       false
    featured        false
    state_boost     false

    latitude          { Faker::Address.latitude }
    longitude         { Faker::Address.longitude }

    trait :published do
      published   true
    end

    trait :featured do
      featured    true
    end

    trait :boosted do
      state_boost true
    end

    trait :invalid do
      listing_type     ""
    end

    trait :person do
      listing_type  'person'
      name          nil
      first_name    { Faker::Name.first_name }
      last_name     { Faker::Name.last_name }
      suffix        { Faker::Name.suffix }
    end
  end
end
