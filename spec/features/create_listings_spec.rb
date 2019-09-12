require 'rails_helper'

feature "Create listings" do
  given(:user){ create(:member, :default) }
  given(:listing_name){ 'The White House' }
  
  before(:each) do
    state = create(:state, name: 'District of Columbia', abbreviation: 'DC')
    create(:city, name: 'Washington', state: state)
    @states = [state]
    @cities = state.cities
  end

  background do
    create(:directory, name: 'Rehabs')
    login_as(user, scope: :member)
  end

  scenario 'Submit a new listing', js: true do
    ensure_on new_listing_path

    close_popups

    select 'Facility', from: 'change_listing_type'
    select 'Rehabs', from: 'change_directory_type'

    fill_in 'listing_name', with: listing_name
    fill_in 'listing_address_1', with: '1600 Pennsylvania Avenue NW'
    fill_in 'listing_address_2', with: 'Suite 105'
    select 'District of Columbia', from: 'listing_state'
    select 'Washington', from: 'listing_city_id'
    fill_in 'listing_zipcode', with: '20500'
    fill_in 'listing_phone', with: '202-456-1111'

    fill_in 'listing[description]', with: 'The White House'
    fill_in 'listing_claims_attributes_0_phone', with: '9999-999999'

    click_button 'Create Listing'

    expect(find('#pending-claims')).to have_content("#{listing_name} (Pending Approval)")
  end
end
