Listing.find_each(start: 1, batch_size: 1000) do |listing|
#Listing.find_each do |listing|
    city = City.where(name: listing.old_city)

    if city.count > 1
      city = City.includes(:state).where("cities.name = '#{listing.old_city}' AND states.abbreviation='#{listing.old_state}'").references(:state)

      if city.count > 0
        city = city[0]
        result_of_update = listing.update(city: city, needs_reviewed: false)
      else
        result_of_update = listing.update(needs_reviewed: true, published: false)
      end
    else
      if city.count == 0
        result_of_update = listing.update(needs_reviewed: true, published: false)
      else
        city = city[0]
        result_of_update = listing.update(city: city, needs_reviewed: false)
      end
    end

    if result_of_update
      p listing
    else
      p listing.errors.messages
      p Listing.find(listing.id)
    end
  #end
  #index+=1
end
