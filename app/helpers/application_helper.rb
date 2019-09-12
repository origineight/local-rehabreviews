module ApplicationHelper
  def star_rating(listing)
    content_tag :div, render_stars(average_score(listing)) + " " + reviews_text(total_ratings(listing)), :class => 'listing-ratings'
  end

  def render_stars(rating)
    content_tag :span, star_icons(rating).html_safe, :class => 'star-ratings'
  end

  def highlight(content = '')
    content_tag :span, content, :class => 'lightblue'
  end

  def star_icons(rating)
    (0...5).map do |position|
      star_type(((rating-position)*2).round)
    end.join
  end

  def reviews_text(rating)
    if rating > 0
      content_tag :span, " (" + pluralize(rating, 'Review') + ")", :class => 'reviews-text has-reviews'
    else
      content_tag :span, " (" + pluralize(rating, 'Review') + ")", :class => 'reviews-text'
    end
  end

  def star_type(value)
    if value <= 0
      '<span class="star empty-star">&#xf006</span>'
    elsif value == 1
      '<span class="star half-star">&#xf006<span>&#xf089</span></span>'
    else
      '<span class="star full-star">&#xf005</span>'
    end
  end

  def meta_tags(obj)
    case obj.class.name
    when 'Listing'
      # Title
      if obj.interventionist? || obj.sober_living? || obj.criminal_attorney? || obj.health?
        meta_title = "#{obj.full_name} Contact Info, Reviews and Feedback"
      elsif obj.sleep?
        meta_title = "#{obj.full_name(title: true)} Sleep Medicine Healthcare Info, Reviews and Feedback"
      elsif obj.methadone?
        meta_title = "#{obj.full_name(title: true)} Methadone, Subutex, Suboxone Support Info, Reviews and Feedback"
      elsif obj.dui_dwi_attorney?
        meta_title = "#{obj.full_name} #{obj.directory.name} Info, Reviews and Feedback"
      elsif obj.meeting?
        meta_title = "#{obj.full_name} #{obj.directory.name} Meetings Info, Reviews and Feedback"
      elsif obj.alternative? || obj.dentist?
        meta_title = "#{obj.full_name} #{obj.title} #{obj.directory.name} Info, Reviews and Feedback "
      elsif obj.military?
        meta_title = "#{obj.full_name} Veteran & Active Military Personnel Healthcare Info, Reviews & Feedback "
      else # pain-management, buprenorphine & therapists
        meta_title = [obj.full_name,obj.city_str,obj.state_abbreviation_str,obj.zipcode].compact.join(', ')
      end

      if obj.health?
        meta_title << " | Healthcare Professionals in #{obj.zipcode}"
      elsif obj.meeting?
        meta_title << " | #{obj.directory.initials} meetings in #{obj.city_state}"
      else
        meta_title << " | #{obj.directory.name}"
      end

      meta title: meta_title

      # Description
      meta_desc = obj.get_meta_description
      meta(description: meta_desc) if meta_desc.present?

      # OG
      if obj.uploads.present?
        obj.uploads.limit(3).each do |upload|
          meta og: { image: upload.image(:profile) }
        end
      elsif !obj.map_image.nil?
        meta og: { image: obj.map_image.url }
      else
        meta og: { image: gmaps_url(obj) }
      end

      rel canonical: root_url + seo_listing_path(@listing).sub('/', '')
    end
  end

  def gmaps_url(obj, opts = {})
    opts = {zoom: 17, size: '640x360'}.merge opts
    "https://maps.googleapis.com/maps/api/staticmap?center=#{obj.latitude},#{obj.longitude}&maptype=satellite&key=#{ENV['GOOGLE_MAPS_API_KEY']}&#{opts.to_query}"
  end

  def mapbox_url(obj)
    "https://api.mapbox.com/v4/mapbox.satellite/pin-l-hospital+f00(#{obj.longitude},#{obj.latitude})/#{obj.longitude},#{obj.latitude},17/640x360.png?access_token=#{ENV['MAPBOX_API_KEY']}"
  end

  def phony(obj,attribute = 'phone')
    value = obj.send(attribute)

    if value.present?
      if obj.therapist?
        value.phony_formatted(:normalize => :US)
      else
        value
      end
    end
  end

  def url_domain(url)
    url.gsub(/http[s]?:\/\//,'')
  end

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def social_sharer_url_for(url, social_network)
    sharer_url = case social_network
    when :facebook
      'https://www.facebook.com/sharer/sharer.php?u='
    when :google
      'https://plus.google.com/share?url='
    else
      'https://twitter.com/intent/tweet?text='
    end
    sharer_url + url
  end

  def post_social_sharer_metas(post, social_network)
    metas = { title: post.title, description: post.description, meta_description: post.meta_description}
    metas[:image] = post.image.url(social_network) if post.image?

    case social_network
    when :tw
      metas[:card] = post.image? ? 'summary_large_image' : 'summary'
    else
      metas.merge!(type: 'article', url: blog_post_url(post), headline: post.title)
    end
    metas
  end

  def listing_page?
    params[:controller] == 'listings' && params[:action] == 'show'
  end

end
