class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location
  helper_method :all_states, :seo_listing_path, :resource_signed_in?, :current_auth_resource
  http_basic_authenticate_with name: 'staging', password: '7oD4RM4NikfhVu', if: :is_staging?
  before_filter :check_for_mobile
  helper_method :mobile_device?

  include CacheableFlash

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  before_filter :set_cache_headers if Rails.env.development?

  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/login" &&
        request.path != "/logout" &&
        request.path != "/register" &&
        request.path != "/members/password/new" &&
        request.path != "/members/password/edit" &&
        request.path != "/members/confirmation" &&
        request.path != "/members/sign_in" &&
        request.path != "/members/sign_out" &&
        request.path != "/admin/login" &&
        request.path != "/admin/logout" &&
        request.path != "/administrators/sign_in" &&
        request.path != "/administrators/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    # check for the class of the object to determine what type it is
    case resource
      when Member then dashboard_path
      when Blogger then :blog_posts_index
      when Administrator then admin_path
    end
  end

  def all_states
    all_states = {
      "al" => {
        "full_state" => "Alabama",
        "abbreviation" => "AL",
        "latitude" => 32.7990,
        "longitude" => -86.8073
      },
      "ak" => {
        "full_state" => "Alaska",
        "abbreviation" => "AK",
        "latitude" => 61.3850,
        "longitude" => -152.2683
      },
      "az" => {
        "full_state" => "Arizona",
        "abbreviation" => "AZ",
        "latitude" => 33.7712,
        "longitude" => -111.3877
      },
      "ar" => {
        "full_state" => "Arkansas",
        "abbreviation" => "AR",
        "latitude" => 34.9513,
        "longitude" => -92.3809
      },
      "ca" => {
        "full_state" => "California",
        "abbreviation" => "CA",
        "latitude" => 36.1700,
        "longitude" => -119.7462
      },
      "co" => {
        "full_state" => "Colorado",
        "abbreviation" => "CO",
        "latitude" => 39.0646,
        "longitude" => -105.3272
      },
      "ct" => {
        "full_state" => "Connecticut",
        "abbreviation" => "CT",
        "latitude" => 41.5834,
        "longitude" => -72.7622
      },
      "de" => {
        "full_state" => "Delaware",
        "abbreviation" => "DE",
        "latitude" => 39.3498,
        "longitude" => -75.5148
      },
      "fl" => {
        "full_state" => "Florida",
        "abbreviation" => "FL",
        "latitude" => 27.8333,
        "longitude" => -81.7170
      },
      "ga" => {
        "full_state" => "Georgia",
        "abbreviation" => "GA",
        "latitude" => 32.9866,
        "longitude" => -83.6487
      },
      "hi" => {
        "full_state" => "Hawaii",
        "abbreviation" => "HI",
        "latitude" => 21.1098,
        "longitude" => -157.5311
      },
      "id" => {
        "full_state" => "Idaho",
        "abbreviation" => "ID",
        "latitude" => 44.2394,
        "longitude" => -114.5103
      },
      "il" => {
        "full_state" => "Illinois",
        "abbreviation" => "IL",
        "latitude" => 40.3363,
        "longitude" => -89.0022
      },
      "in" => {
        "full_state" => "Indiana",
        "abbreviation" => "IN",
        "latitude" => 39.8647,
        "longitude" => -86.2604
      },
      "ia" => {
        "full_state" => "Iowa",
        "abbreviation" => "IA",
        "latitude" => 42.0046,
        "longitude" => -93.2140
      },
      "ks" => {
        "full_state" => "Kansas",
        "abbreviation" => "KS",
        "latitude" => 38.5111,
        "longitude" => -96.8005
      },
      "ky" => {
        "full_state" => "Kentucky",
        "abbreviation" => "KY",
        "latitude" => 37.6690,
        "longitude" => -84.6514
      },
      "la" => {
        "full_state" => "Louisiana",
        "abbreviation" => "LA",
        "latitude" => 31.1801,
        "longitude" => -91.8749
      },
      "me" => {
        "full_state" => "Maine",
        "abbreviation" => "ME",
        "latitude" => 44.6074,
        "longitude" => -69.3977
      },
      "md" => {
        "full_state" => "Maryland",
        "abbreviation" => "MD",
        "latitude" => 39.0724,
        "longitude" => -76.7902
      },
      "ma" => {
        "full_state" => "Massachusetts",
        "abbreviation" => "MA",
        "latitude" => 42.2373,
        "longitude" => -71.5314
      },
      "mi" => {
        "full_state" => "Michigan",
        "abbreviation" => "MI",
        "latitude" => 43.3504,
        "longitude" => -84.5603
      },
      "mn" => {
        "full_state" => "Minnesota",
        "abbreviation" => "MN",
        "latitude" => 45.7326,
        "longitude" => -93.9196
      },
      "ms" => {
        "full_state" => "Mississippi",
        "abbreviation" => "MS",
        "latitude" => 32.7673,
        "longitude" => -89.6812
      },
      "mo" => {
        "full_state" => "Missouri",
        "abbreviation" => "MO",
        "latitude" => 38.4623,
        "longitude" => -92.3020
      },
      "mt" => {
        "full_state" => "Montana",
        "abbreviation" => "MT",
        "latitude" => 46.9048,
        "longitude" => -110.3261
      },
      "ne" => {
        "full_state" => "Nebraska",
        "abbreviation" => "NE",
        "latitude" => 41.1289,
        "longitude" => -98.2883
      },
      "nv" => {
        "full_state" => "Nevada",
        "abbreviation" => "NV",
        "latitude" => 38.4199,
        "longitude" => -117.1219
      },
      "nh" => {
        "full_state" => "New Hampshire",
        "abbreviation" => "NH",
        "latitude" => 43.4108,
        "longitude" => -71.5653
      },
      "nj" => {
        "full_state" => "New Jersey",
        "abbreviation" => "NJ",
        "latitude" => 40.3140,
        "longitude" => -74.5089
      },
      "nm" => {
        "full_state" => "New Mexico",
        "abbreviation" => "NM",
        "latitude" => 34.8375,
        "longitude" => -106.2371
      },
      "ny" => {
        "full_state" => "New York",
        "abbreviation" => "NY",
        "latitude" => 42.1497,
        "longitude" => -74.9384
      },
      "nc" => {
        "full_state" => "North Carolina",
        "abbreviation" => "NC",
        "latitude" => 35.6411,
        "longitude" => -79.8431
      },
      "nd" => {
        "full_state" => "North Dakota",
        "abbreviation" => "ND",
        "latitude" => 47.5362,
        "longitude" => -99.7930
      },
      "oh" => {
        "full_state" => "Ohio",
        "abbreviation" => "OH",
        "latitude" => 40.3736,
        "longitude" => -82.7755
      },
      "ok" => {
        "full_state" => "Oklahoma",
        "abbreviation" => "OK",
        "latitude" => 35.5376,
        "longitude" => -96.9247
      },
      "or" => {
        "full_state" => "Oregon",
        "abbreviation" => "OR",
        "latitude" => 44.5672,
        "longitude" => -122.1269
      },
      "pa" => {
        "full_state" => "Pennsylvania",
        "abbreviation" => "PA",
        "latitude" => 40.5773,
        "longitude" => -77.2640
      },
      "ri" => {
        "full_state" => "Rhode Island",
        "abbreviation" => "RI",
        "latitude" => 41.6772,
        "longitude" => -71.5101
      },
      "sc" => {
        "full_state" => "South Carolina",
        "abbreviation" => "SC",
        "latitude" => 33.8191,
        "longitude" => -80.9066
      },
      "sd" => {
        "full_state" => "South Dakota",
        "abbreviation" => "SD",
        "latitude" => 44.2853,
        "longitude" => -99.4632
      },
      "tn" => {
        "full_state" => "Tennesee",
        "abbreviation" => "TN",
        "latitude" => 35.7449,
        "longitude" => -86.7489
      },
      "tx" => {
        "full_state" => "Texas",
        "abbreviation" => "TX",
        "latitude" => 31.1060,
        "longitude" => -97.6475
      },
      "ut" => {
        "full_state" => "Utah",
        "abbreviation" => "UT",
        "latitude" => 40.1135,
        "longitude" => -111.8535
      },
      "vt" => {
        "full_state" => "Vermont",
        "abbreviation" => "VT",
        "latitude" => 44.0407,
        "longitude" => -72.7093
      },
      "va" => {
        "full_state" => "Virginia",
        "abbreviation" => "VA",
        "latitude" => 37.7680,
        "longitude" => -78.205
      },
      "wa" => {
        "full_state" => "Washington",
        "abbreviation" => "WA",
        "latitude" => 47.3917,
        "longitude" => -121.5708
      },
      "wv" => {
        "full_state" => "West Virginia",
        "abbreviation" => "WV",
        "latitude" => 38.4680,
        "longitude" => -80.9696
      },
      "wi" => {
        "full_state" => "Wisconsin",
        "abbreviation" => "WI",
        "latitude" => 44.2563,
        "longitude" => -89.6385
      },
      "wy" => {
        "full_state" => "Wyoming",
        "abbreviation" => "WY",
        "latitude" => 42.7475,
        "longitude" => -107.2085
      },
      "dc" => {
        "full_state" => "Washington DC",
        "abbreviation" => "DC",
        "latitude" => 38.8964,
        "longitude" => -77.0262
      },
      "as" => {
        "full_state" => "American Samoa",
        "abbreviation" => "AS",
        "latitude" => -14.3064,
        "longitude" => -170.6950
      },
      "gu" => {
        "full_state" => "Guam",
        "abbreviation" => "GU",
        "latitude" => 13.4502,
        "longitude" => 144.7874
      },
      "mp" => {
        "full_state" => "Northern Mariana Islands",
        "abbreviation" => "MP",
        "latitude" => 15.1063,
        "longitude" => 145.7065
      },
      "fm" => {
        "full_state" => "Federated States of Micronesia",
        "abbreviation" => "FM",
        "latitude" => 6.8874,
        "longitude" => 158.2150
      },
      "pr" => {
        "full_state" => "Puerto Rico",
        "abbreviation" => "PR",
        "latitude" => 18.1987,
        "longitude" => -66.3526
      },
      "vi" => {
        "full_state" => "Virgin Islands",
        "abbreviation" => "vi",
        "latitude" => 18.3434,
        "longitude" => -64.8671634
      },
    }
    all_states
  end

  def current_auth_resource
    if member_signed_in?
      current_member
    elsif blogger_signed_in?
      current_blogger
    end
  end

  def resource_signed_in?
    member_signed_in? || blogger_signed_in?
  end

  def seo_listing_path(listing)
    dir_slug = ''
    dir_slug = "/#{listing.directory.slug}" unless ["mental-health", "rehabs", "pain-management", "buprenorphine", "therapists", "interventionists", "sober-livings"].include?(listing.directory.slug)
    "#{dir_slug}/#{listing.city_str.nil? ? '' : listing.city_str.parameterize}-#{listing.state_abbreviation_str.nil? ? '' : listing.state_abbreviation_str.downcase}/#{listing.slug}"
  end

  def current_ability
    @current_ability or @current_ability = Ability.new(current_auth_resource)
  end

  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)

    @directories = Rails.cache.fetch('all_directories', expires_in: 1.day) do
      Directory.select(:id, :name, :slug).all
    end
  end

  def require_admin
    redirect_to :root unless current_member.is_administrator?
  end

  def check_for_mobile
    session[:mobile_override] = params[:mobile] if params[:mobile]
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end

  def mobile_device?
    if session[:mobile_override]
  	  session[:mobile_override] == "1"
    else
      (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
    end
  end

private
  def is_staging?
    Rails.env.staging?
  end
end
