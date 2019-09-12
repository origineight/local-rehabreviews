require 'rails_helper'

feature "Claim listings" do
  given(:user){ create(:member, :default) }
  given!(:listing){ create(:listing, :published) }

  scenario 'Registered user claims listing' do
    login_as(user, scope: :member)

    ensure_on edit_listing_path(listing)
    #ensure_on seo_listing_path(listing)

    #click_link 'Apply to edit this entry'

    #expect(page).to have_content 'Apply to Manage This Profile'

    #fill_in 'listing[phone]', with: '999999999'
    #click_button 'Update Listing'

    #expect(listing).to eq('999999999')
    #expect(find('#pending-claims')).to have_content("#{listing.name} (Pending Approval)")
  end
end
