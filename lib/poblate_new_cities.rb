=begin
  Script that Create the new Cities that are needed to match the listings
  With the information in City table
  Created_at: February 3rd - 2016
=end

File.open(Rails.root.join('lib','Cleaned_Cities.csv'), "r").each_line do |line|
  begin
    items = line.strip.split(';')
    city_name = items[1].strip
    state_name = items[2].strip

    city = City.includes(:state).where("lower(cities.name) = '#{city_name.downcase}' AND lower(states.abbreviation) = '#{state_name.downcase}'").references(:state)

    if city.count == 0
      #The city have to be create
      state = State.where("lower(abbreviation) = '#{state_name.downcase}'")[0]

      if state.nil?
        p "The following state is not created;#{state_name}"
      else
        city = City.create(name: city_name.titleize, state: state)


        if city.nil?
          p "The City-State was not created;#{city_name};#{state_name};#{city.errors}"
        else
          p "The City-State was created;#{city_name};#{state_name}"
        end
      end
    end
  rescue Exception => e
    p "ERROR in line;#{line};#{e.message};#{e.backtrace.inspect}"
  end
end
