class Zipcode < ActiveRecord::Base
  validates_uniqueness_of :postal
end
