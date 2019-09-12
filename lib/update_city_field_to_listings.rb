=begin
  Script to update city_id, from the old_city renamed field after refactoring
  Listing model
  Created_at: January 14th - 2015
=end

p "Script Begin"
index = 1
Listing.find_each do |listing|
  p "Listing Number: #{index}"
  city = City.where(name: listing.old_city)

  if city.count > 1
    city = City.includes(:state).where("cities.name = '#{listing.old_city}' AND states.abbreviation='#{listing.old_state}'").references(:state)

    if city.count > 0
      city = city[0]
      listing.update(city: city, needs_reviewed: false)
    else
      listing.update(needs_reviewed: true)
    end
  else
    if city.count == 0
      listing.update(needs_reviewed: true)
    else
      city = city[0]
      listing.update(city: city, needs_reviewed: false)
    end
  end
  index+=1
end
p "Script End"
