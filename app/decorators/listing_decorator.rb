class ListingDecorator

  def self.decorate(params)
    listing = Listing.friendly.find(params[:id])
    ratings = listing.ratings.approved

    nearby_query = {"filtered" => {"filter" => {"bool" => {"must" => [{"term" => {"directory_id" => listing.directory.id}}, {"geo_distance" => {"distance" => "30km", "pin.location" => {"lat" => listing.latitude, "lon" => listing.longitude}}}], "must_not" => [{"term" => {"_id" => listing.id}}]}}}}
    sort_query = [{"_geo_distance" => {"pin.location" => {'lat' => listing.latitude, 'lon' => listing.longitude}, 'order' => 'asc', 'unit' => 'km', 'distance_type' => 'plane'}}]
    nearbys = Listing.search("query" => nearby_query, size: 6, 'sort' => sort_query).records
    q = {"filtered" => {"filter" => {"bool" => {"must" => [{"term" => {"featured" => true}}, {"term" => {"published" => true}}]}}}}
    featured = Listing.search("query" => q).records.sort_by {rand}.slice(0,4)
    reviews = Review.all.sort_by {rand}.slice(0,3)

    return {
      'object' => listing,
      'reviews' => reviews,
      'ratings' => ratings,
      'nearbys' => nearbys,
      'featured' => featured
    }
  end

end
