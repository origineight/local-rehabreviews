geo_config = {:use_https => true, :timeout => 5 }

if Rails.env.production?
  geo_config.merge!(:lookup => :mapbox, :api_key => ENV['MAPBOX_API_KEY'])
else
  geo_config.merge!(:lookup => :mapbox, :api_key => ENV['MAPBOX_API_KEY'])
end

Geocoder.configure(geo_config)
