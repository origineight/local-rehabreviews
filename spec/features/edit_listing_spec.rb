require 'rails_helper'

feature "Edit listing" do
  given!(:listing){ create(:listing) }
  given!(:claim){ create(:claim, :approved, member: user, listing: listing) }
  given(:new_name){ "New listing name" }

  background do
    load "#{Rails.root}/db/seeds.rb"
    login_as(user, scope: :member)
  end

  context "As Admin" do
    given!(:user){ create(:member, :default, :admin) }

    scenario "edits listings from admin dashboard" do
      expect{
        ensure_on admin_listings_path
        find("#edit-listing-#{listing.id}").click
        fill_in "Name", with: new_name
        click_button "Update Listing"
        listing.reload
      }.to change(listing, :name).to new_name
    end
  end

  context "As owner" do
    given!(:user){ create(:member, :default) }

    scenario "edits own listing" do
      expect{
        ensure_on dashboard_path
        find("#edit-listing-#{listing.id}").click
        fill_in "Name", with: new_name
        click_button "Update Listing"
        listing.reload
      }.to change(listing, :name).to new_name
    end
  end

end
