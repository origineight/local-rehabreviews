=begin
  This script is used to update the duplicate field of Listings with the information
  of the DuplicateListing model
  Created at: February 19th / 2016
=end

ids_of_duplicated_listings = DuplicateListing.pluck('listing_associated_id')

counter = 1
ids_of_duplicated_listings.each do |id|
  listing = Listing.find(id)
  listing.update_columns(duplicate: true)
  p "Number of Listings Processed: #{counter}"
  counter+=1
end
