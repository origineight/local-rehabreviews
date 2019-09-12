require 'rails_helper'

feature "Boost listing" do
  given(:user){ create(:member, :admin) }
  given!(:listing){ create(:listing, :published) }

  background do
    login_as(user, scope: :member)
  end

  scenario 'Admin boosts listing by state' do
    ensure_on edit_listing_path(listing)
    #ensure_on seo_listing_path(listing)

    #click_link 'Edit Listing'
    check 'Boost by State'
    click_button 'Update Listing'
    listing.reload
    expect(listing).to be_state_boost
  end
end
