require 'rails_helper'

feature "User logs out" do
  scenario 'user logs out correctly' do
    user_logs_in
    expect(page).to have_content('Logged in as: Joe Doe')

    page.find('#site-footer').click_link('Logout')
    expect(page).to_not have_content('Logged in as: Joe Doe')
  end
end
