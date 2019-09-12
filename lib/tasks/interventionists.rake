namespace :interventionists do

  desc "This task creates the Interventionists directory and imports the data from CSV"
  task :import => :environment do
    dir = Directory.find_or_create_by(:name => "Interventionists")

    url = "http://rehab-reviews.s3.amazonaws.com/assets/interventionalists.json"
    response = HTTParty.get(url)
    data = JSON.parse(response.body)
    data.each_with_index do |obj,i|
      l = Listing.new obj
      l.published = true
      l.directory = dir
      l.listing_type = 'person'
      unless l.geocoded?
        zip = Zipcode.find_by(postal: l.zipcode)
        if zip
          l.latitude = zip.latitude
          l.longitude = zip.longitude
        else
          # fallback to state geocoding
          a = ApplicationController.new
          if a.all_states[l.state.downcase].present?
            l.latitude = a.all_states[l.state.downcase]['latitude']
            l.longitude = a.all_states[l.state.downcase]['latitude']
          else
            # fallback to default U.S. geocode values
            l.latitude = 38.8833
            l.longitude = 77.0167
          end
        end
      end
      l.save!
      puts "saved interventionist #{i+1} of #{data.size}"
      sleep 0.2
    end

  end
end
