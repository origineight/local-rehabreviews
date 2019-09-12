=begin
  Script to update city_id, from the old_city renamed field after refactoring
  Listing model, into multithreaded way
  Created_at: January 19th - 2015
=end
=begin
number_of_threads = 2
(0..number_of_threads).each do |i|
  p "Script Start"
  Thread.new do
    p "Inside Thread"
    spec = ActiveRecord::Base.spec
    ActiveRecord::ConnectionPool.open(spec) do |connection|
      ActiveRecord::Base.connection = connection

      counter = Listing.where(needs_reviewed: nil).count('id')
      p "Number of the Thread: #{i}, Contador: #{counter}"

      while counter > 0 do
        p "Number of the Thread: 1, Contador: #{counter}"
        listing = Listing.where(needs_reviewed: nil).limit(1)[0]
        city = City.where(name: listing.old_city)

        if city.count > 1
          city = City.includes(:state).where("cities.name = '#{listing.old_city}' AND states.abbreviation='#{listing.old_state}'").references(:state)

          if city.count > 0
            city = city[0]
            p listing.update(city: city, needs_reviewed: false) ? 'ok' : listing.errors
          else
            p listing.update(needs_reviewed: true) ? 'ok' : listing.errors
          end
        else
          if city.count == 0
            p listing.update(needs_reviewed: true) ? 'ok' : listing.errors
          else
            city = city[0]
            p listing.update(city: city, needs_reviewed: false) ? 'ok' : listing.errors
          end
        end
        counter = Listing.where(needs_reviewed: nil).count('id')
      end
      p "There are not more records to Update!!!"
    end
  end
end
=end


=begin
p "Script Begin"
Listing.find_each do |listing|
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

    if result_of_update == false
=end

      #p listing.errors.messages
      #p Listing.find(listing.id)
=begin
    end

end
p "Script End"
=end
number_of_listings = Listing.count('id')
number_of_workers = 60
batch_size = number_of_listings/number_of_workers
counter = 1
(1..number_of_workers).each do |item|
    UpdateCityStateWorker.perform_async(counter,batch_size)
    counter+=batch_size
end
