class BenefitsChecksNotifierWorker
  include Sidekiq::Worker

  def perform(benefits_check_id)
    benefits_check = BenefitsCheckLead.find(benefits_check_id)

    # Notifiy owners
    BenefitsCheckLeadMailer.owners_notification(benefits_check).deliver if Rails.env.production?
    
    # Notify submitters
    BenefitsCheckNotification.all.each do |notification|
      BenefitsCheckLeadMailer.submitters_notification(benefits_check.email, notification).deliver if notification.applicable_to?(benefits_check)
    end
  end
end