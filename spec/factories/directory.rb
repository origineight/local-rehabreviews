FactoryGirl.define do
  factory :directory do
    name { ['Mental Health','Rehabs','Pain Management','Buprenorphine','Therapists'].sample }
  end
end
