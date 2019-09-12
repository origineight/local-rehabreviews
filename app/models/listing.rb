require 'open-uri'
require 'elasticsearch/model'

class Listing < ActiveRecord::Base

  # External resources definitions
  extend FriendlyId
  extend Importable

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  geocoded_by :address
  #friendly_id :full_name, use: :slugged
  friendly_id :slug_candidates, use: :slugged

  has_attached_file :map_image
  has_attached_file :medium_map_image
  has_attached_file :small_map_image, styles: { tiny: '100x70#' }

  index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join('_') if Rails.env.test?

  settings :analysis => {:analyzer => {:case_insensitive_sort => {:tokenizer => "keyword", :filter => ["lowercase"]}}} do
    mapping do
      indexes :sort_name, type: 'string', :fields => {"lower_case_sort" => {"type" => "string", "analyzer" => "case_insensitive_sort"}, "first_letter" => {"type" => "string", "index" => "not_analyzed"}}
      indexes :published, type: 'boolean'
      indexes :featured, type: 'boolean'
      indexes :pin do
        indexes :location, type: 'geo_point'
      end
    end
  end

  # Scopes
  scope :boosted_by_state, -> { where(:state_boost => true) }
  scope :custom, -> { where(:custom => true) }
  scope :featured, -> { where(:featured => true) }
  scope :published, -> { where(:published => true) }
  scope :published_and_not_duplicated, -> { where(published: true, duplicate: false, mark_for_deletion: false)}

  # Validations
  #validates :name, uniqueness: { scope: [:address_1, :address_2]}
  validate :uploads_count_validation
  validates :listing_type, :directory, presence: true
  validates :address_1, :address_2, length: { maximum: 100 }
  validates :custom_service, length: { maximum: 50000 }
  validates_associated :city

  # validates :description, length: { minimum: 325, maximum: 10000, tokenizer: lambda { |str| str.scan(/\w+/) }, too_long: 'must be less than 10000 words', too_short: "must have at least 325 words"}
  validates :first_name, :last_name, presence: true, length: { maximum: 40 }, unless: lambda { |l| l.listing_type != 'person' }
  validates :listing_type, inclusion: { in: ['person', 'facility'] }
  validates :meta_description, length: { maximum: 160 }
  validates :name, presence: true, length: { maximum: 100 }, unless: lambda { |l| l.listing_type != 'facility' }
  validates :zipcode, presence: true, format: { with: /\A\d{5}(?:[-\s]\d{4})?\z/i }
  validates :website, :review_url, format: { with: URI::regexp(%w(http https)), message: 'is not valid, please include "http://"' }, allow_blank: true
  validates_attachment :map_image, :medium_map_image, :small_map_image, content_type: { content_type: /^image\/(png|gif|jpeg)/ }, size: { in: 0..2.megabytes }

  # Associations
  belongs_to :directory
  belongs_to :city
  has_one :state, through: :city
  has_many :category_links, dependent: :destroy
  has_many :duplicate_listings, dependent: :destroy
  has_many :uploads, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :claims, dependent: :destroy
  has_many :members, :through => :claims do
    def approved
      where("claims.approved = ?", "yes")
    end
  end
  has_many :categories, :through => :category_links do
    def boosted
      where("category_links.boosted = ?", true)
    end
  end
  has_and_belongs_to_many :insurances
  has_and_belongs_to_many :languages

  # Nested resources
  accepts_nested_attributes_for :categories, :claims

  # Callbacks
  after_save :generate_sort_name
  after_validation :geocode, :if => lambda{ |obj| obj.address_1_changed? or !obj.published or obj.latitude.nil? or obj.longitude.nil? }

  # Methods
  def slug_candidates
    [:full_name, [:full_name, :id_for_slug]]
  end

  def id_for_slug
    generated_slug = normalize_friendly_id(full_name)
    counter = 1
    begin
      temp_slug = "#{generated_slug}-#{counter}"
      counter+=1
    end while self.class.exists?(slug: temp_slug)
    counter-=1
  end

  def normalize_friendly_id_full_name
    normalize_friendly_id(full_name)
  end

  def as_indexed_json(options={})
    as_json(
      only: [:sort_name, :listing_type, :zipcode, :directory_id, :published, :featured],
      include: {category_links: { only: [:category_id]},
                city: { only: [:name]},
                state: {only: [:abbreviation]}
               }).merge pin: {location: { lat: self.latitude, lon: self.longitude }}
  end

  def self.boosted(ids)
    includes(:category_links).where(:category_links => {:boosted => true}).where(:category_links => {:category_id => ids})
  end

  def boosted?(ids)
    self.category_links.where(:boosted => true).where(:category_id => ids).size > 0
  end

  def is_boosted?
    self.category_links.where(:boosted => true).size > 0
  end

  def self.categorized(ids)
    includes(:category_links).where(:category_links => {:category_id => ids})
  end

  def city_str
    if self.city.nil?
      self.old_city
    else
      self.city.name
    end
  end

  def state_str
    if self.city.nil?
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
        "ap" => {
          "full_state" => "AP",
          "abbreviation" => "ap",
          "latitude" => 18.3434,
          "longitude" => -64.8671634
        },
        "ae" => {
          "full_state" => "AE",
          "abbreviation" => "ae",
          "latitude" => 18.3434,
          "longitude" => -64.8671634
        }
      }
      all_states[self.old_state.downcase]["full_state"] rescue ''
    else
      self.city.state.name
    end
  end

  def state_abbreviation_str
    if self.city.nil?
      self.old_state
    else
      self.city.state.abbreviation
    end
  end

  def state_id_selected
    if self.city.nil?
      nil
    else
      self.city.state.id
    end
  end

  def sleep?
    self.directory.slug == 'sleep-medicine'
  end

  def methadone?
    self.directory.slug == 'methadone'
  end

  def military?
    self.directory.slug == 'military-support'
  end

  def alternative?
    self.directory.slug == 'alternative-medicine'
  end

  def dentist?
    self.directory.slug == 'dentists'
  end

  def alcoholic?
    self.directory.slug == 'alcoholics-anonymous'
  end

  def overeater?
    self.directory.slug == 'overeaters-anonymous'
  end

  def narcotic?
    self.directory.slug == 'narcotics-anonymous'
  end

  def marijuana?
    self.directory.slug == 'marijuana-anonymous'
  end

  def gambler?
    self.directory.slug == 'gamblers-anonymous'
  end

  def meeting?
    alcoholic? || overeater?|| narcotic? || gambler? || marijuana?
  end

  def dui_dwi_attorney?
    self.directory.slug == 'dui-dwi-attorneys'
  end

  def therapist?
    self.directory.slug == 'therapists'
  end

  def interventionist?
    self.directory.slug == 'interventionists'
  end

  def criminal_attorney?
    self.directory.slug == 'criminal-attorney'
  end

  def sober_living?
    self.directory.slug == 'sober-livings'
  end

  def mental_health?
    self.directory.slug == 'mental-health'
  end

  def rehab?
    self.directory.slug == 'rehabs'
  end

  def pain?
    self.directory.slug == 'pain-management'
  end

  def buprenorphine?
    self.directory.slug == 'buprenorphine'
  end

  def assisted?
    self.directory.slug == 'assisted-living'
  end

  def health?
    mental_health? || rehab?
  end

  def categorized?(ids)
    self.category_links.where(:category_id => ids).size > 0
  end

  def category_list
    categories.map{|c| c.name }.compact.join(',') if categories.any?
  end

  def areas_of_law
    additional_data.gsub('Area of Law: ','') if criminal_attorney?
  end

  def boosted_by_state?(state)
    if state.present?
      true if self.state_boost == true && self.state_abbreviation_str == state.upcase
    end
  end

  def full_name(opts = {})
    if listing_type == 'facility'
      name
    elsif listing_type == 'person'
      full_name = ''
      full_name += first_name if first_name.present?
      full_name += ' ' + middle_name if middle_name.present?
      full_name += ' ' + last_name if last_name.present?
      full_name += ', ' + suffix if suffix.present?
      full_name += ', ' + title if opts[:title].present? && title.present?
      full_name
    end
  end

  def sortable_name
    if listing_type == 'facility'
      name.upcase
    elsif listing_type == 'person'
      sortable_name = ''
      sortable_name += last_name if last_name.present?
      sortable_name += ', ' + first_name if first_name.present?
      sortable_name += ' ' + middle_name if middle_name.present?
      sortable_name += ' ' + facility_name if facility_name.present?
      sortable_name = sortable_name.strip.upcase
      sortable_name
    end
  end

  def meta_name
    if listing_type == 'facility'
      name
    elsif listing_type == 'person'
      meta_name = ''
      meta_name += title + ' ' if title.present?
      meta_name += first_name if first_name.present?
      meta_name += ' ' + middle_name if middle_name.present?
      meta_name += ' ' + last_name if last_name.present?
      meta_name += ', ' + suffix if suffix.present?
      meta_name
    end
  end

  def city_state
    if self.city.nil?
      "#{[old_city, old_state].compact.join(', ')}"
    else
      "#{[city_str, state_abbreviation_str].compact.join(', ')}"
    end
  end

  def address
    if self.country=='US'
      if self.address_2.blank?
        "#{[address_1, city_str, state_abbreviation_str].compact.join(', ')} #{zipcode}"
      else
        "#{[address_1, address_2, city_str, state_abbreviation_str].compact.join(', ')} #{zipcode}"
      end
    else
      if self.address_2.blank?
        "#{address_1} #{country} #{zipcode}"
      else
        "#{[address_1, address_2].compact.join(', ')} #{country} #{zipcode}"
      end
    end
  end

  def google_maps_url(opts = {})
    query_string_params = {
      center: "#{self.latitude}\,#{self.longitude}", zoom: 17, size: '640x360',
      maptype: 'satellite', key: ENV['GOOGLE_MAPS_API_KEY']
    }.merge(opts).to_query

    "https://maps.googleapis.com/maps/api/staticmap?#{query_string_params}"
  end

  def download_google_maps_images!
    self.map_image = open(URI(google_maps_url))
    self.medium_map_image = open(URI(google_maps_url(zoom: 15, size: '400x300', markers: "color:red|#{self.latitude}\,#{self.longitude}")))
    self.small_map_image = open(URI(google_maps_url(size: '168x140')))

    self.save
  end

  def download_mapbox_images!
    self.map_image = open(URI("https://api.mapbox.com/v4/mapbox.satellite/pin-l-hospital+f00(#{longitude},#{latitude})/#{longitude},#{latitude},17/640x360.png?access_token=#{ENV['MAPBOX_API_KEY']}"))
    self.medium_map_image = open(URI("https://api.mapbox.com/v4/mapbox.satellite/pin-l-hospital+f00(#{longitude},#{latitude})/#{longitude},#{latitude},15/400x300.png?access_token=#{ENV['MAPBOX_API_KEY']}"))
    self.small_map_image = open(URI("https://api.mapbox.com/v4/mapbox.satellite/pin-l-hospital+f00(#{longitude},#{latitude})/#{longitude},#{latitude},15/168x140.png?access_token=#{ENV['MAPBOX_API_KEY']}"))
    self.save
  end

  def get_meta_description
    meta_desc = if meta_description.present?
      meta_description
    elsif methadone?
      "with their Methadone, Subutex, or Suboxone healthcare support"
    elsif military?
      "with their Military personnel healthcare support"
    elsif alternative?
      "with their Alternative healthcare support"
    elsif dentist?
      "with their Dentist healthcare support"
    elsif meeting?
      "with their #{directory.name} meeting"
    elsif dui_dwi_attorney?
      "hiring them as a DUI/DWI lawyer or utilizing their skills for general legal support"
    elsif therapist?
      "with their professional therapy services"
    elsif interventionist?
      "with their sober living environment"
    elsif criminal_attorney?
      "hiring them as a lawyer or utilizing their skills for general legal support"
    elsif sober_living?
      "with their sober living environment"
    elsif pain?
      "with their Pain management healthcare services"
    elsif health? || buprenorphine? || assisted?
      "with their Professional healthcare services"
    else
      nil
    end

    if meta_desc.present?
      "Rehab Reviews provides authentic and useful reviews from people who have first-hand experience #{meta_desc} in #{city_state}."
    end
  end

  def last_modification
    if self.ratings.any?
      self.ratings.last.created_at
    else
      self.created_at
    end
  end

  def new_seo_listing
    "/#{self.directory.slug}/#{self.city_str.nil? ? '' : self.city_str.parameterize}-#{self.state_abbreviation_str.nil? ? '' : self.state_abbreviation_str.downcase}/#{self.slug}"
  end

  def seo_listing
    dir_slug = ''
    dir_slug = "/#{self.directory.slug}" unless ["mental-health", "rehabs", "pain-management", "buprenorphine", "therapists", "interventionists", "sober-livings"].include?(self.directory.slug)
    "#{dir_slug}/#{self.city_str.nil? ? '' : self.city_str.parameterize}-#{self.state_abbreviation_str.nil? ? '' : self.state_abbreviation_str.downcase}/#{self.old_slug.nil? ? self.slug : self.old_slug}"
  end

  private
    def uploads_count_validation
      return if uploads.blank?
      errors.add(:uploads, "Limit 10 Image Uploads") if uploads.size > 10
    end

    def generate_sort_name
      self.update_column(:sort_name, self.sortable_name)
    end
end
