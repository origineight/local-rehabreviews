=begin
  This script generate the file: lib/Duplicate_Listings_Information.csv
  This file is needed for doing curl and test redirections are good
  Created at: February 10th / 2016
=end

main_url = "https://rehab-reviews-staging.herokuapp.com"
File.open(Rails.root.join('lib','Duplicate_Listings_Information.csv'), 'w') { |file|
  DuplicateListing.limit(100).each do |duplicate_listing|
    file.write("Id,#{duplicate_listing.id},Original url,#{main_url+duplicate_listing.listing_associated.seo_listing},Redirected url,#{main_url+duplicate_listing.listing.new_seo_listing}\r\n")
  end
  Listing.where('old_slug IS NULL').limit(100).each do |listing|
    duplicate_listings = DuplicateListing.where(listing_associated: listing)[0]

    if !duplicate_listings.nil?
      listing = duplicate_listings.listing
    end
    file.write("Id,#{listing.id},Original url,#{main_url+listing.seo_listing},Redirected url,#{main_url+listing.new_seo_listing}\r\n")
  end
  Listing.where('old_slug IS NOT NULL').limit(100).each do |listing|
    duplicate_listings = DuplicateListing.where(listing_associated: listing)[0]

    if !duplicate_listings.nil?
      listing = duplicate_listings
    end
    file.write("Id,#{listing.id},Original url,#{main_url+listing.seo_listing},Redirected url,#{main_url+listing.new_seo_listing}\r\n")
  end
}
