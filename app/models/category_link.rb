class CategoryLink < ActiveRecord::Base
  belongs_to :category
  belongs_to :listing
end
