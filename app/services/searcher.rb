class Searcher
  def make_search(params)

    if params[:directory].present?
      @directory = Directory.friendly.find(params[:directory].downcase)
    else
      @directory = Directory.friendly.find('rehabs')
    end

    filter_query = {"filtered" => {"filter" => {"bool" => {"must" => [{"term" => {"directory_id" => @directory.id}}]}}}}

    cats = params[:categories]
    sort_hash = [{"sort_name.lower_case_sort" => {"order" => 'asc', 'unmapped_type' => 'string'}}]

    if cats.present?
      catq = {
        "terms" => {
          "category_links.category_id" => cats,
          "execution" => "or"
        }
      }
      filter_query["filtered"]["filter"]["bool"]["must"] << catq
    elsif params[:category_id]
      the_cat = Category.friendly.find(params[:category_id])
      params[:categories] = []
      params[:categories] << the_cat.id
      catq = {
        "term" => {
          "category_links.category_id" => the_cat.id
        }
      }
      filter_query["filtered"]["filter"]["bool"]["must"] << catq
    end

    if params[:q].present?
      term_hash = {"match" => {"sort_name" => {"query" => params[:q]}}}
      filter_query["filtered"]["query"] = term_hash
    end

    if params[:alpha]
      term_hash = {"match_phrase_prefix" => {"sort_name.lower_case_sort" => {"query" => params[:alpha]}}}
      filter_query['filtered']['query'] = term_hash
    end

    ## zip code or state and city
    if params[:z].present?
      zip = Zipcode.find_by(postal: params[:z])
      if zip
        zip_hash = {"geo_distance" => {"distance" => "100km", "pin.location" => {"lat" => zip.latitude, "lon" => zip.longitude}}}
        sort_hash = [{"_geo_distance" => {"pin.location" => {'lat' => zip.latitude, 'lon' => zip.longitude}, 'order' => 'asc', 'unit' => 'km', 'distance_type' => 'plane'}}]
        filter_query['filtered']['filter']['bool']['must'] << zip_hash
      else
        zip_hash = {"geo_distance" => {"distance" => "1km", "pin.location" => {"lat" => -85, "lon" => 0}}}
        filter_query['filtered']['filter']['bool']['must'] << zip_hash
      end
    else
      if params[:state]
        state_hash = {"query" => {"match_phrase" => {"state.abbreviation" => params[:state].upcase}}}
        filter_query['filtered']['filter']['bool']['must'] << state_hash
      end
      if params[:city]
        city_hash = {"query" => {"match_phrase" => {"city.name" => params[:city].titleize}}}
        filter_query['filtered']['filter']['bool']['must'] << city_hash
      end
    end

    if params[:q].present?
      sort_hash = '_score'
    end

    if params[:sort].present?
      sort_hash = {}

      if params[:order] == "desc"
        order = "desc"
      else
        order = "asc"
      end

      if params[:sort] == "name"
        sort_hash["sort_name.lower_case_sort"] = {"order" => order}
      elsif params[:sort] == "city"
        sort_hash["city.name"] = {"order" => order}
      end
    end

    published_hash = {"term" => {"published" => true}}
    filter_query['filtered']['filter']['bool']['must'] << published_hash

    if params[:categories] && params[:state]
      #TODO it's very important, when all of this City, State is finished
      @featured_listings = @directory.listings.includes(:city, :uploads).published.where(:old_state => params[:state].upcase).boosted(params[:categories]).shuffle
      @featured_listings_1 = @directory.listings.includes(city: :state).published.where("states.abbreviation = ?", params[:state].upcase).references(:states).boosted(params[:categories]).shuffle
      @featured_listings = (@featured_listings + @featured_listings_1).uniq
    elsif params[:state]
      @featured_listings = @directory.listings.includes(:city, :uploads).published.boosted_by_state.where(:old_state => params[:state].upcase).shuffle
      @featured_listings_1 = @directory.listings.includes(city: :state).published.where("states.abbreviation = ?", params[:state].upcase).references(:states).shuffle
      @featured_listings = (@featured_listings + @featured_listings_1).uniq
    elsif params[:z]
      @featured_listings = @directory.listings.includes(:city, :uploads).published.where(:zipcode => params[:z]).boosted(params[:categories]).shuffle
    else
      @featured_listings = @directory.listings.includes(:city, :uploads).published.boosted(params[:categories]).shuffle
    end

    @listings = Listing.includes(:city, :uploads).search("query" => filter_query, size: 200, 'sort' => sort_hash).records.to_a

    @listings = (@featured_listings + @listings).uniq
    @listings = Kaminari.paginate_array(@listings).page(params[:page]).per(10)
  end

end
