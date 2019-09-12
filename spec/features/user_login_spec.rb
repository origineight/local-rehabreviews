require 'rails_helper'

# Logged in state relies on presence/absence of "Logged in as" message
# instead of flash messages, since the latter are loaded via JS (due page caching issues)
# and js testing would be slower.

feature "User logs in" do
  scenario 'user fills registration form correctly' do
    user_logs_in

    expect(page).to have_content('Logged in as: Joe Doe')
  end

  scenario 'user enters wrong credentials' do
    ensure_on login_path
    fill_in 'Email', with: 'joedoe@mail.com'
    fill_in 'Password', with: 'wrong'
    click_button 'Log in'

    expect(page).to_not have_content('Logged in as: Joe Doe')
  end
end
