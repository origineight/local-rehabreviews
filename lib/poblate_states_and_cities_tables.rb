=begin
  Script to poblate State and Cities tables
  Created_at: January 14th - 2015
=end
p "Script Begin"
CS.states(:us).each do |key, item|
  state = State.create(name: item, abbreviation: key)
  p "Created State: #{item}, Begin Creation of Cities"
  CS.cities(key, :us).each do |item_2|
    City.create(name: item_2, state: state)
  end
  p "Cities of State: #{item}, were created!"
end
p "Script End"
