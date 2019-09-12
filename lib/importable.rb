module Importable
  COLUMN_MAP = {
    'Zip'=>'zipcode',
    # NPI DATA shared mapping
      'Address'=>'address_1',
      'Provider Organization Name Legal Business Name' => 'name',
      'Provider Last Name Legal Name' => 'last_name',
      'Provider First Name' => 'first_name',
      'Provider Middle Name' => 'middle_name',
      'Provider Credential Text' => 'title',
      'Provider Name Prefix Text' => 'additional_data',
      'Provider Name Suffix Text' => 'suffix',
      'Provider First Line Business Practice Location Address' => 'address_1',
      'Provider Second Line Business Practice Location Address' => 'address_2',
      'Provider Business Practice Location Address City Name' => 'city',
      'Provider Business Practice Location Address State Name' => 'state',
      'zipfix' => 'zipcode',
      'Provider Business Practice Location Address Telephone Number' => 'phone',
      'Provider Business Practice Location Address Fax Number' => 'fax',
      'TYPE' => 'category',
  }

  CATEGORY_MAP = {
    'dui-dwi' => 'DUI/DWI offenders',
    'Mental Health' => 'Psychiatric/Mental Health',
    'Psychiatry' => 'Psychiatric/Mental Health',
    'Psychiatric' => 'Psychiatric/Mental Health',
    'Child & Adolescent Psychiatry' => 'Psychiatric/Mental Health, Child & Adolescent',
    'Mental Health (Including Community Mental Health Center)' => 'Psychiatric/Mental Health, Community',
    'Adult Mental Health' => 'Psychiatric/Mental Health, Adult',
    'Adolescent and Children Mental Health' => 'Psychiatric/Mental Health, Child & Adolescent',
    'Psychoanalyst' => 'Psychoanalysis',
    'Seniors or older adults' => 'Seniors/older adults',
    'Pain Management' => 'Pain Medicine & Management',
    'Pain Medicine' => 'Pain Medicine & Management',
    'Chronic Pain Management' => 'Pain Medicine & Management',
    'Interventional Physical Medicine' => 'Interventional Physical Medicine & Rehabilitation',
  }

  DIRECTORY_MAP = {
    'Clinical' => 'Rehabs',
    'Addiction Psychiatry' => 'Rehabs',
    'Nutrition Support' => 'Rehabs',

    'Psychiatric/Mental Health' => 'Mental Health',
    'Psychiatric Unit' => 'Mental Health',
    'Forensic Psychiatry' => 'Mental Health',
    'Geriatric Psychiatry' => 'Mental Health',
    'Psychosomatic Medicine' => 'Mental Health',
    'Psychiatric/Mental Health, Adult' => 'Mental Health',
    'Psychiatric/Mental Health, Child & Adolescent' => 'Mental Health',
    'Behavioral Neurology & Neuropsychiatry' => 'Mental Health',
    'Psychiatric/Mental Health, Community' => 'Mental Health',
    'Psychiatric/Mental Health, Chronically Ill' => 'Mental Health',
    'Psychiatric/Mental Health, Geropsychiatric' => 'Mental Health',
    'Psychiatric/Mental Health, Child & Family' => 'Mental Health',

    'Developmental – Behavioral Pediatrics' => 'Therapists',
    'Case Manager/Care Coordinator' => 'Therapists',
    'Holistic' => 'Therapists',
    'Dance Therapist' => 'Therapists',

    'Clinical' => 'Therapists',
    'Mental Health' => 'Mental Health',
    'Dietitian, Registered' => 'Mental Health',
    'Counselor' => 'Therapists',
    'Psychologist' => 'Therapists',
    'Professional' => 'Mental Health',
    'Cognitive & Behavioral' => 'Therapists',
    'Marriage & Family Therapist' => 'Therapists',
    'Addiction (Substance Use Disorder)' => 'Therapists',
    'Counseling' => 'Therapists',
    'Social Worker' => 'Mental Health',
    'Clinical Neuropsychologist' => 'Mental Health',
    'Clinical Child & Adolescent' => 'Therapists',
    'Nutritionist' => 'Mental Health',
    'Case Management' => 'Mental Health',
    'Prescribing (Medical)' => 'Mental Health',
    'Nutrition, Metabolic' => 'Mental Health',
    'Neuroscience' => 'Mental Health',
    'Rehabilitation' => 'Mental Health',
    'Family' => 'Therapists',
    'Group Psychotherapy' => 'Therapists',
    'Nutrition Support' => 'Mental Health',
    'Nutrition, Renal' => 'Mental Health',
    'Psychoanalysis' => 'Therapists',
    'Poetry Therapist' => 'Therapists',

    'Pain Medicine & Management' => 'Pain Management',
    'Sleep Medicine' => 'Sleep Medicine',
    'Miltary' => 'Military Support',
    'Methadone' => 'Methadone',
    'Assisted Living' => 'Assisted Living',
    'Facilities' => 'Mental Health',
    'Therapists' => 'Therapists',
    'Dentist' => 'Dentists',
    'Alternative Medicine' => 'Alternative Medicine',
    'Addiction Medicine' => 'Rehabs',
  }

  def logger
    @@logger ||= Logger.new("#{Rails.root}/log/import.log")
  end

  def build_sort_name(data)
    sn = ''

    if data['name'].present?
      sn = data['name']
    else
      sn << data['last_name']           if data['last_name'].present?
      sn << ', ' + data['first_name']   if data['first_name'].present?
      sn << ' ' + data['middle_name']   if data['middle_name'].present?
      sn << ' ' + data['facility_name'] if data['facility_name'].present?
    end

    sn.strip.upcase
  end

  def csv_import(filename, dirname='', options = {})
    # options:
    # - mapping: object mapping source's columns to model fields
    # - custom_atts: overrides any attribute
    raise "A source file must be specified" unless filename.present?
    raise "Source file #{filename} doesn't exist" unless File.exists?(filename)

    mapping = options[:mapping] || {}
    def_category = options[:default_category]
    custom_atts = options[:custom_atts] || {}
    custom_atts[:added_by] = 'new_import'

    csv = CSV.read(filename, :headers => true)

    default_atts = { published: false } # Default atts for all imported records
    dir = Directory.find_or_create_by(:name => dirname) if dirname.present?
    directory_names = Directory.pluck(:name).map(&:downcase)

    # Auto map same-name fields only if model has attribute and is not already mapped
    auto_mapping = {}
    csv.headers.each do |csv_col|
      auto_mapping[csv_col] = csv_col.downcase if column_names.include?(csv_col.downcase) && !mapping.include?(csv_col)
    end
    mapping = auto_mapping.merge(COLUMN_MAP).merge(mapping)

    csv.each_with_index do |row, i|
      listing_directory = dir
      data = {'categories' => []}

      # Data mapping
      mapping.each do |k,v| # k:source's column name   v:model's attribute
        k, position = k.split('@') # Map field with position

        if row.has_key?(k)
          value = row[position.present? ? position.to_i : k] || ''

          if value.present?
            if v == 'directory'
              listing_directory = Directory.find_or_create_by(:name => value.titleize)
            elsif v == 'category'
              listing_categories = []

              value.split(',').each do |category_name|
                if category_name.present?
                  category_name = CATEGORY_MAP[category_name] || category_name

                  if dirname.blank? && (DIRECTORY_MAP[category_name].present? || directory_names.include?(category_name.downcase))
                    listing_dirname = DIRECTORY_MAP[category_name] || category_name
                    listing_directory = Directory.find_or_create_by(:name => listing_dirname)
                  end

                  listing_categories << Category.find_or_create_by(:name => category_name)
                end
              end

              data['categories'] = listing_categories

            elsif column_names.include?(v)

              # Special formatting
              case v
              when 'zipcode'
                value = value.rjust(5,'0') if value =~ /\A\d{4}\z/
              when 'phone'
                value.slice! ' Call firm now'
              end

              case k
              when 'Area of Law'
                value = "Area of Law: #{value.gsub!(/,(?!\s)/,', ')}"
              when 'Day'
                value << " #{row['Time']}"
              end

              data[v] = value
            end
          end
        end
      end

      data['categories'] << Category.find_or_create_by(:name => def_category) if def_category.present?

      #TODO create a new class method to perform this lookup but using non virtual fields
      listing = find_or_initialize_by(sort_name: build_sort_name(data), directory: listing_directory)

      if listing.persisted?
        def_atts = {}  # Disable def_atts for existing records
        data['categories'].push(*listing.categories) if listing.categories.any? # Keep existing categories
      else
        def_atts = default_atts
        data['listing_type'] ||= data['first_name'].present? ? 'person' : 'facility'
      end

      listing.attributes = [data,def_atts,custom_atts].reduce(&:merge)

      unless listing.geocoded?
        zip = Zipcode.find_by(postal: listing.zipcode)

        if zip
          listing.latitude = zip.latitude
          listing.longitude = zip.longitude
        elsif listing.state.present?
          # fallback to state geocoding
          a = ApplicationController.new
          if a.all_states[listing.state.downcase].present?
            listing.latitude = a.all_states[listing.state.downcase]['latitude']
            listing.longitude = a.all_states[listing.state.downcase]['latitude']
          else
            # fallback to default U.S. geocode values
            listing.latitude = 38.8833
            listing.longitude = 77.0167
          end
        end
      end

      if listing.valid?
        action = listing.persisted? ? 'Updated' : 'Saved'
        listing.save
        puts "#{action}: #{listing_directory.name} with ID #{listing.id} – ##{i+1} of #{csv.size}"
      else
        failure_msg = "Failed import from #{filename} listing '#{listing.full_name}' @ row #{i}"
        puts failure_msg
        logger.error failure_msg
        logger.debug listing.errors.messages
      end

      sleep 0.2 if listing.changed?
    end
  end
end
