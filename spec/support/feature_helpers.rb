module FeatureHelpers
  def ensure_on(path)
    visit(path) unless current_path == path
  end

  def user_logs_in(user = nil)
    user = create(:member, :default) if user.blank?
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Passw0rd.'
    click_button 'Log in'
  end

  def close_popups
    popup = first("#benefits-check-modal")
    popup.find("button.close").click if popup.present?
  end

end
