class MailchimpController < ApplicationController
  def submit
    respond_to do |format|
      format.js {
        begin
          MailchimpConnect.new.send(params)
        rescue Gibbon::MailChimpError => e
          @error_msg = e.message
        end
      }
    end
  end
end