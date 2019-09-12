=begin
  Script to update listings new_city and new_state_abbreviation
  Fields, when saving the listing its trigger generate_sort_name method
  Which update these fields
  Created_at: April 3rd - 2016
=end

counter = 1
Listing.find_each do |listing|
  p "Listing Counter: #{counter}"
  listing.save
  counter+=1
end
