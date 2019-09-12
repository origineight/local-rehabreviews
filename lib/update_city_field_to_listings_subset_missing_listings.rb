counter = 1
p "Script Begin"
Listing.where(needs_reviewed: nil).find_each do |listing|
  city = City.where("lower(name) = '#{listing.old_city.downcase}'")

  begin
    if city.count > 1
      city = City.includes(:state).where("lower(cities.name) = '#{listing.old_city.downcase}' AND lower(states.abbreviation) = '#{listing.old_state.downcase}'").references(:state)

      if city.count > 0
        city = city[0]
        result_of_update = listing.update_columns(city_id: city.id, needs_reviewed: false)
      else
        result_of_update = listing.update_columns(needs_reviewed: true)
      end
    else
      if city.count == 0
        result_of_update = listing.update_columns(needs_reviewed: true)
      else
        city = city[0]
        result_of_update = listing.update_columns(city_id: city.id, needs_reviewed: false)
      end
    end

    if result_of_update == false
      p listing.errors.messages
    end
    p "Number of Records Processed: #{counter}"
    counter+=1
  rescue
    p "#{listing.id}: ERROR"
    listing.update_columns(needs_reviewed: true)
  end

end
p "Script Finish"
