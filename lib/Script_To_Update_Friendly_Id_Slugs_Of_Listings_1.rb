=begin
  This Script is used to update the listings with a slug with hexadecimal
  By one more friendly
  Created at: February 11th - 2016
=end

counter = 1125479
Listing.find_each(start: 1125479) do |listing|
  if DuplicateListing.where(listing_associated: listing).count('id') == 0
    generated_slug = listing.normalize_friendly_id_full_name
    if (listing.slug.size > generated_slug.size) && listing.old_slug.nil?
      counter_1 = 1
      begin
        temp_slug = "#{generated_slug}-#{counter_1}"
        counter_1+=1
      end while Listing.exists?(slug: temp_slug)

      listing.update_columns(old_slug: listing.slug, slug: temp_slug)
    end
  end

  p "Number of Records Processed: #{counter}"
  counter+=1
end
