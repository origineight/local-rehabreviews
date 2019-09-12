require 'rails_helper'

feature "User signs up" do
  scenario 'user fills registration form correctly' do
    ensure_on register_path
    fill_in 'Email', with: 'joedoe@mail.com'
    fill_in 'Password', with: 'Passw0rd.'
    fill_in 'Password confirmation', with: 'Passw0rd.'
    fill_in 'First name', with: 'Joe'
    fill_in 'Last name', with: 'Doe'
    click_button 'Register'

    expect(page).to have_content('Logged in as: Joe Doe')
  end

  scenario 'user skips some fields on registration form' do
    ensure_on register_path
    click_button 'Register'

    expect(page).to have_content('Email can\'t be blank')
  end
end
