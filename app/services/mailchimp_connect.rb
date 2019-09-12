class MailchimpConnect
  def send(params)
    client = Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
    response = client.lists.subscribe({
      :id => ENV['MAILCHIMP_LIST_ID'],
      :email => {:email => params[:email]},
      :double_optin => true,
      :update_existing => false,
      :replace_interests => true,
      :send_welcome => false
    })
  end
end