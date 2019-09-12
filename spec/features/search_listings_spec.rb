require 'rails_helper'

feature "Search listings" do
  given!(:listing_name){ 'Mercy Hospital' }
  given!(:dir){ create(:directory, name: 'Rehabs') }
  given!(:listing){ create(:listing, :published, directory: dir, name: listing_name) }

  background do
    Listing.__elasticsearch__.import
    sleep 1
    ensure_on "/"
  end

  scenario "searching by name" do
    close_popups

    within "#home-search" do
      fill_in "q", with: listing_name
      select listing.directory.name, from: "directory-type"
      click_button "Search"
    end
    expect(page).to have_content(listing_name)
  end
end
