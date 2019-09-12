FactoryGirl.define do
  factory :category do
    name        { Faker::Lorem.sentence(1, true, 3) }
    description { Faker::Lorem.sentence }

    meta_title        { name }
    meta_description  { Faker::Lorem.sentence }
    category_subhead  { Faker::Lorem.sentence(3, true, 3) }

    trait :boosted do
      boostable       true
    end
  end
end
