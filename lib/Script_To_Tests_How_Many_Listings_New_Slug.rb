=begin
  This Script is used to Know how many Listings need to update their slugs
  Created at: February 15th - 2016
=end

counter = 1
counter_1 = 0
Listing.find_each do |listing|
  if DuplicateListing.where(listing_associated: listing).count('id') == 0
    if listing.slug.size > listing.full_name.size
      counter_1+=1
    end
  end

  p "Number of Records Processed: #{counter}"
  counter+=1
end
p "The number of records that need to update their slug is: #{counter_1}"
