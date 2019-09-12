namespace :publisher do
  def log(level, msg)
    logger ||= Logger.new("#{Rails.root}/log/publisher.log")
    logger.send(level, msg)
    puts msg # show when manual execution
  end

  desc "Publishes 750 listings per day"
  task :publish, [:import_type] => [:environment] do |t, args|

    args.with_defaults(:import_type => 'new_import')

    per_day = 715

    listings = Listing.where(:added_by => args[:import_type], :published => false)
    count = listings.count
    offset = count > per_day ? count - per_day + 1 : 0 # +1 since rand is not-inclusive

    listings = listings.offset(rand(offset)).limit(per_day)

    log :info, "===== Starting publishing for #{args[:import_type]} @ #{Time.zone.now.strftime('%D %R')} ====="

    listings.each do |lst|
      lst.published = true

      begin
        lst.save!
        puts "##{lst.id} - #{lst.full_name}"
      rescue
        log :error, "#{lst.id} - #{lst.errors.full_messages.join('; ')}"
      end
    end
    log :info, "===== Finished publishing @ #{Time.zone.now.strftime('%D %R')} ====="
  end

end
