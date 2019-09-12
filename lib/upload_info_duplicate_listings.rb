=begin
  Script to upload the info of the file: lib/Backup_Duplicate_Listings_Table.csv,
  To the table: duplicate_listings
  Created at: February 8th - 2016
=end

counter = 1
File.open(Rails.root.join('lib','Backup_Duplicate_Listings_Table.csv'), "r").each_line do |line|
  begin
    items = line.strip.split(',')
    listing_id = items[1]
    listing_associated_id = items[3]

    DuplicateListing.create(listing_id: listing_id, listing_associated_id: listing_associated_id)
  rescue

  end
  p "Number of Records added: #{counter}"
  counter+=1
end
