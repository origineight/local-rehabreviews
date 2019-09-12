namespace :import do
  desc "Invokes an import"
  task :execute, [:task, :source, :target] => [:environment] do |t, args|
    args[:task] || args[:source] || raise("Usage: rake import:execute[<task_name>,<source_url>,<target_path:optional>]")

    target = parse_target(args[:target],args[:source])

    Rake::Task['import:download_csv'].invoke(args[:source],target)
    Rake::Task["import:#{args[:task]}"].invoke(target)
  end


  desc "Downloads CSV files to import them"
  task :download_csv, [:source, :target] => [:environment] do |t, args|
    args[:source] || raise("Usage: rake import:download_csv[<source>,<target:optional>]")
    target = parse_target(args[:target],args[:source])

    if target.exist?
      puts "File already exists in #{target}"
    else
      puts "Fetching #{args[:source]}"

      begin
        response = HTTParty.get(args[:source])

        if response.code != 200
          bad_response_msg = "Bad response - #{filename} #{response.code} #{response.message}"
          logger.error bad_response_msg
          raise bad_response_msg
        else
          puts "Copying to #{target}"
          File.open(target,'w') do |f|
            f.write(response.body.force_encoding('UTF-8'))
            puts "File saved successfully"
          end
        end
      rescue HTTParty::Error => e
        logger.error "HTTParty error - #{filename} #{e.message}"
        raise e
      end
    end

    puts "Download complete."
  end


  desc "Imports DUI/DWI attorneys data from CSV"
  task :dui,[:source] => [:environment] do |t,args|
    raise "A source file must be specified" unless args[:source].present?

    mapping = {
      'Languages' => 'category',
      'Practice Area' => 'additional_data',
    }
    custom_atts = {
    }

    puts "Starting import of DUI/DWI attorneys"
    Listing.csv_import(args[:source], 'DUI-DWI Attorneys', mapping: mapping, custom_atts: custom_atts)
  end


  desc "Imports AA Meetings data from CSV"
  task :meetings, [:source] => [:environment] do |t,args|
    raise "A source file must be specified" unless args[:source].present?

    mapping = {
      'Title' => 'name',
      'Street Address FIX' => 'address_1',
      'Meeting Location' => 'address_2',
      'City FIX' => 'city',
      'Zip Code' => 'zipcode',
      'FellowShip' => 'directory',
      'Day' => 'additional_data',
    }
    custom_atts = {
      'title' => nil # Auto-mapping would populate this field with source's Title column, but it's not the type of Title we want
    }

    puts "Starting import of AA Meetings"
    Listing.csv_import(args[:source], false, mapping: mapping, custom_atts: custom_atts)
  end


  desc "Imports Criminal Attorney data from CSV"
  task :criminal_attorneys, [:source] => [:environment] do |t,args|
    raise "A source file must be specified" unless args[:source].present?

    mapping = {
      'Address@1' => 'address_1',
      'Title' => 'name',
      'Category' => 'category',
      'Area of Law' => 'additional_data',
    }
    custom_atts = {
      'title' => nil # Auto-mapping would populate this field with source's Title column, but it's not the type of Title we want
    }

    puts "Starting import of Criminal Attorney"
    Listing.csv_import(args[:source], 'Criminal Attorney', mapping: mapping, custom_atts: custom_atts)
  end


  desc "Imports NPI data from CSV"
  task :npi,[:source] => [:environment] do |t,args|
    raise "A source file must be specified" unless args[:source].present?

    mapping = { }
    custom_atts = { }

    puts "Starting import of NPI"
    Listing.csv_import(args[:source], false, mapping: mapping, custom_atts: custom_atts)
  end


  desc "Publishes listings added by import tasks"
  task :publish, [:limit] => [:environment] do |t, args|
    args.with_defaults(:limit => 15000)

    puts "Starting auto-publishing"

    ll = Listing.where(:added_by => 'new_import').where(:published => false).order("RANDOM()").limit(args[:limit])

    puts "Publishing #{ll.size} records"

    ll.each do |l|
      l.published = true
      l.save
      puts "Auto-published ##{l.id} - #{l.full_name}."
    end

    puts "Auto-publishing done."
  end

  def parse_target(tgt,src)
    if tgt.blank?
      uri = URI.parse(src)
      filename = File.basename(uri.path)
    else
      filename = tgt
    end

    Rails.root.join("tmp",filename)
  end

end
