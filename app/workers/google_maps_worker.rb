class GoogleMapsWorker
  include Sidekiq::Worker

  def perform(listing_id)
    listing = Listing.find(listing_id)
    begin
      listing.download_mapbox_images!
    rescue OpenURI::HTTPError => e
      logger.error "Couldn't download image for '#{listing.slug}' due to: #{e.message}"
    end
  end
end