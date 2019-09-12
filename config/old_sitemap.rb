start_time = Time.now

SitemapGenerator::Interpreter.send :include, ListingsHelper

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{ENV['APP_DOMAIN'] || 'local.rehabreviews.com'}"

# The directory to write sitemaps to locally
SitemapGenerator::Sitemap.public_path = 'tmp/'

# Set this to a directory/path if you don't want to upload to the root of your `sitemaps_host`
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

if Rails.env.production? || Rails.env.staging?
  # The remote host where your sitemaps will be hosted
  SitemapGenerator::Sitemap.sitemaps_host = "http://rehab-reviews.s3.amazonaws.com"

  # Site map adapter to host your sitemap in the specified host above
  SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
end

# Create index for sitemap
SitemapGenerator::Sitemap.create_index = true

# SITEMAPS GENERATION
SitemapGenerator::Sitemap.create do

  usa_states = State.all

  # - Category
  #   routes: ['/category/:category_id']
  puts 'Mapping categories...'
  Category.all.each do |category|
    add "/category/#{category.slug}", priority: 0.2, lastmod: category.updated_at
  end

  # - Directory
  #   routes: ['/directories/:directory', '/directories/:directory/:state', '/directories/:directory/:state/:city', '/alpha/:directory/:alpha']
  #   Questions: [ Should we map all the directories? or only the 'Rehab' directory? ]
  puts 'Mapping directories...'
  opts = { priority: 0.3 }
  Directory.all.each do |directory|
    add search_directory_path(directory.slug), opts.merge(lastmod: directory.updated_at)

    # TODO: Comment the :if bellow if the '/alpha'route exists for the all the directories
    if directory.name.downcase == 'rehabs'
      ('a'..'z').each { |alpha| add("/alpha/#{directory.slug}/#{alpha}", opts)  }
    end

    usa_states.each do |state|
      add search_directory_state_path(directory.slug, state.abbreviation.parameterize), opts
      state.cities.each do |city|
        add search_directory_state_city_path(directory.slug, state.abbreviation.parameterize, city.name.parameterize), opts
      end
    end

    # TODO: Uncomment the code bellow once there are cities regitered in the database
    # City.all.each do |city|
    #   directory_state_path = "#{directory_path}/#{city.state}"
    #   add directory_state_path, opts
    #   add "#{directory_state_path}/#{city.slug}", opts
    # end
  end

  # - City(no reoutes)

  # - Claim(requires login)
  #   Routes: [resources + (:approve, :decline)]

  # - Insurance(no routes)

  # - Language(no routes)

  # - Member(requires login)

  # - Rating
  #   Routes: [resources(:new, :create), Listing: {resources(:new, :create)}]
  #   Comments: [
  #     Multiple and different routes pointing to the same controller action
  #     Routes pointing to controller undefined actions e.g :index
  #   ]
  puts 'Mapping Ratings...'
  add new_rating_path, priority: 0.2

  # - Review(no routes)

  # - Upload
  #   Routes: [Listing: {resources(:new, :create, :destroy)}]

  # - Zipcode(no routes)

  # - Post
  puts 'Mapping blog posts...'
  Post.all.each do |post|
    add blog_post_page_path(post), priority: 0.4, lastmod: post.updated_at
  end

  # --- OTHERS
  puts 'Mapping others...'
  ['about', 'benefits-check', 'login', 'logout', 'register', search: { changefreq: 'monthly' }, blog: { changefreq: 'monthly' }].each do |route|
    path = route.is_a?(Hash) ? route.keys[0] : route
    opts = if route.is_a? Hash
      route.values[0]
    else
      { priority: 0.2, changefreq: 'yearly' }
    end

    add "/#{path}", opts
  end

  # --- RESOURCES
  # - Listing
  #   Routes: [ resources(:show), '/:location_data/:id', Rating, Upload ]
  #   Comments: [
  #     Due to the order of the routes, the route "get /listings' => 'listings#search'" is never going be reached
  #     Multiple and different routes pointing to the same controller action
  #     Routes pointing to controller undefined actions e.g :index
  #   ]
  print "\nMapping listings"
  links_per_sitemap = 45_000
  resource_batch_size = 1_000
  all_listings_size = Listing.published_and_not_duplicated.count('id')
  number_of_sitemaps = (all_listings_size / links_per_sitemap.to_f).ceil
  opts = { priority: 0.6, changefreq: 'weekly' }
  puts " (#{number_of_sitemaps} sitemaps)..."
  number_of_sitemaps.times do |i|
    sitemap_name = "listings#{i + 1}"
    processed_resources = 0
    group(filename: sitemap_name) do
      resources_to_process = Listing.published_and_not_duplicated.limit(links_per_sitemap).offset(i * links_per_sitemap).count('id')
      batches_to_process = (resources_to_process / resource_batch_size.to_f).ceil

      batches_to_process.times do |j|
        # Determine next set of resources to process
        limit = if processed_resources + resource_batch_size > links_per_sitemap
          links_per_sitemap - processed_resources
        else
          resource_batch_size
        end
        offset = (i * links_per_sitemap) + (j * resource_batch_size)

        # Add resources to the current sitemap
        counter = 1
        Listing.published_and_not_duplicated.limit(limit).offset(offset).each do |listing|
          # TODO: Solve problem with the action associated to the route bellow, then uncomment.
          # add listing_path(listing), opts.merge(lastmod: listing.updated_at)

          # Ignore duplicated listings
          add "/#{listing.directory.name.parameterize}/#{listing.city_str.parameterize}-#{listing.state_abbreviation_str.parameterize}/#{listing.slug}", opts.merge(lastmod: listing.updated_at)

          # TODO: uncomment the next lines if interested on mapping those routes
          # add new_listing_rating_path(listing), priority: 0.2
          # add new_listing_upload_path(listing), priority: 0.2
          p "Processed Listings: #{i+1}-#{j+1}-#{counter}"
          counter+=1
        end

        processed_resources += limit
      end
    end
  end
end
end_time = Time.now
p "Time Spent: #{end_time - start_time}"
