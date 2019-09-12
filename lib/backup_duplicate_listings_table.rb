=begin
  Script to generate the file: lib/Backup_Duplicate_Listings_Table.csv,
  To Locally Backup the table: duplicate_listings, and then put it into
  Production or Staging
  Created at: February 8th - 2016
=end

File.open(Rails.root.join('lib','Backup_Duplicate_Listings_Table.csv'), 'w') { |file|
  counter = 1
  DuplicateListing.find_each do |duplicate_listing|
    file.write("listing_id,#{duplicate_listing.listing_id},listing_associated_id,#{duplicate_listing.listing_associated_id}\r\n")
    p "Number of Records Processed: #{counter}"
    counter+=1
  end
}
