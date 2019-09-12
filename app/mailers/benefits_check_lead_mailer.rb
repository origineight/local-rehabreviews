class BenefitsCheckLeadMailer < ActionMailer::Base

  default from: 'Rehab Reviews <contact@rehabreviews.com>'

  def owners_notification(benefits_check)
    @benefits_check = benefits_check
    mail to: BenefitsCheckLead::NOTIFY_TO, subject: 'New Benefits Check Request from Rehab Reviews Directory'
  end

  def submitters_notification(email, notification)
    @notification = notification
    mail to: email, subject: @notification.subject
  end
end