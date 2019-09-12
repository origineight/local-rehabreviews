=begin
  Script to update listings where needs_reviewed = false
  The city is going to be match with the zipcode saved in the record
  And the name of the city and the state abbreviation saved into the tables:
  cities and states
  Created_at: February 1st - 2015
=end
counter = 1
p "Script Begin"
Listing.where(needs_reviewed: true).find_each do |listing|
  if listing.zipcode.nil?
    p "The Listing Id: #{listing.id}, has not Zipcode"
  else
    zipcode = Zipcode.where(postal: listing.zipcode)[0]

    if zipcode.nil?
      p "This Zipcode: #{listing.zipcode}, does not exist in the Database"
    else
      city = City.includes(:state).where("lower(cities.name) = '#{zipcode.city.downcase}' AND lower(states.abbreviation) = '#{zipcode.state.downcase}'").references(:state)

      begin
        if city.count > 0
          city = city[0]
          result_of_update = listing.update_columns(city_id: city.id, needs_reviewed: false)

          if result_of_update == false
            p listing.errors.messages
          end
        else
          p "The City: #{zipcode.city}, State: #{zipcode.state}, does not match with the info in Databases"
        end

        p "Number of Records Processed: #{counter}"
        counter+=1
      rescue
        p "#{listing.id}: ERROR"
        listing.update_columns(needs_reviewed: true)
      end
    end
  end
end
p "Script Finish"
