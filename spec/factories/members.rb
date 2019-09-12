FactoryGirl.define do
  factory :member do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    email                 { Faker::Internet.free_email(first_name) }
    password              'Passw0rd.'

    trait :admin do
      is_administrator  true
    end

    trait :default do
      first_name    'Joe'
      last_name     'Doe'
      email         'joedoe@mail.com'
      password      'Passw0rd.'
    end
  end
end
