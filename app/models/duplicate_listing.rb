class DuplicateListing < ActiveRecord::Base
  belongs_to :listing
  belongs_to :listing_associated, class_name: 'Listing', foreign_key: 'listing_associated_id'
end
