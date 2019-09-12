module ListingsHelper

  def average_score(listing)
    scored_ratings = listing.ratings.approved.where.not(:score => nil)
    if scored_ratings.size > 0
      average_score = scored_ratings.average(:score).round(1)
    else
      average_score = 0
    end
  end

  def total_ratings(listing)
    total_ratings = listing.ratings.approved.where.not(:score => nil).size
  end

  def state_info(state)
    info = all_states[state]

    # Line bellow is quick fix to solve error 500 when state is not present in the all_states hash
    # TODO: remove this method once city-state refactor is done. This is a very bad approach
    info ? info : { "full_state" => state.upcase }
  end

  def page_title
    if params[:z].present?
      ttl = params[:z]
    elsif params[:city].present?
      ttl = params[:city]
    elsif params[:state].present?
      ttl = state_info(params[:state].downcase)["full_state"]
    elsif params[:category_id]
      cat = Category.friendly.find(params[:category_id])
      ttl = cat.name
    else
      ttl = "Search"
    end
    return ttl
  end

  def facility(listing)
    if listing.facility_name.present?
      listing.facility_name
    else
      listing.full_name
    end
  end
end
