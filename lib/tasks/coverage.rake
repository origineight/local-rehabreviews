namespace :spec do
  desc "Run specs with coverage and console output"
  task :coverage => ["coverage:console"]

  namespace :coverage do
    desc "Run specs with coverage and console output"
    task :console => :environment do
      Rake::Task['spec'].invoke
    end

    desc "Run specs with coverage and HTML output"
    task :html => :environment do
      ENV['COV_FORMAT'] = 'html'
      Rake::Task['spec'].invoke
    end
  end
end
