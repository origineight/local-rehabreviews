=begin
  Script to find duplicates of listings, all the listings must have the info in the following varaiables:
  full_name_field and duplicate
  Created at: February 4th - 2016
=end

p "Start matching the data"
counter = 1
Listing.find_each do |listing|
  begin
    if listing.duplicate
      listing.update_columns(duplicate: false)

      duplicates = Listing.where("full_name_field = ? AND duplicate = ? AND city_id = ? AND lower(address_1) = ?", listing.full_name_field, true, listing.city_id, listing.address_1.downcase)

      if duplicates.count > 0
        temp = []
        duplicates.each do |listing_duplicate|
          listing_duplicate.update_columns(duplicate: false)
          temp.push("#{listing_duplicate.full_name}-#{listing_duplicate.id}-#{listing_duplicate.friendly_id}")
        end
        temp = temp.join(';')
        p "The Following listing name:,#{listing.full_name},id:,#{listing.id},friendly_id:,#{listing.friendly_id}, duplicate with the followings (name-id-friendly_id):,#{temp}"
      end
    end
  rescue Exception => e
    p "ERROR MATCHING,id,#{listing.id},friendly id,#{listing.friendly_id},#{e.message}"
  end
  p "Listing Number: #{counter}"
  counter+=1
end
p "Finish matching the data"
