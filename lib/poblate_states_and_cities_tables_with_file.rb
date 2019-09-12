#Encoding: utf-8
=begin
  Script to poblate State and Cities tables with the info
  At file city-state.csv
  Created_at: January 27th - 2015
=end
cont = 0
CSV.foreach(Rails.root.join('lib','city-states.csv'), encoding: 'utf-8') do |row|
  if cont >=1
    city_name = row[0]
    state_name = row[1]
    state_abbreviation = row[2]
    state = State.where(name: state_name, abbreviation: state_abbreviation)[0]

    if state.nil?
      state = State.create(name: state_name, abbreviation: state_abbreviation)
    end

    city = City.where(name: city_name, state: state)[0]

    if city.nil?
      City.create(name: city_name, state: state)
    end
  end
  cont+=1
  p "Counter Progress: #{cont}"
end
