=begin
  Script to find duplicates of listings, all the listings must have the info in the following varaiables:
  full_name_field and duplicate
  Created at: February 5th - 2016
=end
if Listing.where(full_name_field: nil).count('id') > 0
  p "Start preparing the data"
  counter = 1
  Listing.where(full_name_field: nil).find_each do |listing|
    begin
      name = listing.full_name.downcase
      listing.update_columns(full_name_field: name)
    rescue Exception => e
      p "ERROR,id,#{listing.id},friendly id,#{listing.friendly_id},#{e.message}"
    end
    p "PREPARING COUNTER: #{counter}"
    counter+=1
  end
  p "Finish preparing the data"
end

p "Start matching the data"
counter = 1
Listing.find_each do |listing|
  begin
    if listing.duplicate
      if listing.address_1.nil?
        duplicates = Listing.where("full_name_field = ? AND duplicate = ? AND city_id = ?", listing.full_name_field, true, listing.city_id)
      else
        duplicates = Listing.where("full_name_field = ? AND duplicate = ? AND city_id = ? AND lower(address_1) = ?", listing.full_name_field, true, listing.city_id, listing.address_1.downcase)
      end

      number_of_duplicates = duplicates.count
      listing.update_columns(duplicate: false, number_of_duplicates: number_of_duplicates)

      if number_of_duplicates > 0
        duplicates.each do |listing_duplicate|
          listing_duplicate.update_columns(duplicate: false)
          listing.duplicate_listings.create(listing_associated: listing_duplicate)
        end
      end
    end
  rescue Exception => e
    p "ERROR MATCHING,id,#{listing.id},friendly id,#{listing.friendly_id},#{e.message}"
  end
  p "Number of Listing Processed: #{counter}"
  counter+=1
end
p "Finish matching the data"

p "Start selecting the real main listing"
counter = 1
Listing.where("number_of_duplicates > 0").find_each do |listing|
  main_slug = listing.slug
  main_listing = listing

  duplicate_listings = listing.duplicate_listings
  duplicate_listings.each do |duplicate_listing|
    if duplicate_listing.listing_associated.slug.size < main_slug.size
      main_slug = duplicate_listing.listing_associated.slug
      main_listing = duplicate_listing
    end
  end

  if main_listing != listing
    listing.duplicate_listings.detroy_all
    main_listing.duplicate_listings.create(listing_associated: listing)
    duplicate_listings.each do |duplicate_listing|
      if duplicate_listing != main_listing
        main_listing.duplicate_listings.create(listing_associated: duplicate_listing)
      end
    end
  end
  p "Number of Listing Processed Matching: #{counter}"
  counter+=1
end
p "Finish selecting the real main listing"
