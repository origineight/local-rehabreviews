=begin
  Script to update listings where needs_reviewed = false
  The city is going to be match with the zipcode saved in the record
  And the name of the city and the state abbreviation saved into the tables:
  cities and states
  Version 2 uses the gem zip-codes
  Created_at: February 2nd - 2015
=end
counter = 1
p "Script Begin"
zipcodes = ZipCodes.load

Listing.where(needs_reviewed: true).find_each do |listing|
  if listing.zipcode.nil?
    p "The Following Listing Id has not Zipcode, #{listing.id}"
  else
    listing_zipcode = listing.zipcode.split('-')

    zipcode = zipcodes[listing_zipcode[0]]

    if zipcode.nil?
      p "The following Zipcode does not exist in the Database, #{listing_zipcode[0]}"
    else
      city = City.includes(:state).where("lower(cities.name) = '#{zipcode[:city].downcase}' AND lower(states.abbreviation) = '#{zipcode[:state_code].downcase}'").references(:state)

      begin
        if city.count > 0
          city = city[0]
          result_of_update = listing.update_columns(city_id: city.id, needs_reviewed: false)

          if result_of_update == false
            p "ERROR UPDATING: #{listing.errors.messages}"
          end
        else
          p "The following City - State does not match with the info in Databases, #{zipcode[:city]}, #{zipcode[:state_code]}"
        end

        #p "Number of Records Processed: #{counter}"
        counter+=1
      rescue
        p "ERROR , #{listing.id}"
        listing.update_columns(needs_reviewed: true)
      end
    end
  end
end
p "Script Finish"
