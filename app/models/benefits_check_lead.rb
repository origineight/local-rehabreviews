class BenefitsCheckLead < ActiveRecord::Base

  # Constants
  NOTIFY_TO = %w(info@cleanandsobermedia.com jason.wilcox@serviceindustriesinc.com jayson.sullins@serviceindustriesinc.com richard@cliffsidemalibu.com zurbina@gmail.com johnna.hose@serviceindustriesinc.com)

  # Enums
  enum insurance_type: ['PPO', 'HMO', 'Medicare', 'Medi-Cal', 'Obamacare', 'State Insurance', 'TRICARE', 'Other', "I don't have insurance"]
  enum seeking_help_for: ['self', 'loved one']

  # Validations
  validates :name, :phone, :email, :insurance_type, :seeking_help_for, presence: true
  validates :email, format: { with: Devise::email_regexp }

  # Callbacks
  after_save :notify_submition

  # Methods
  private
    def notify_submition
      BenefitsChecksNotifierWorker.perform_async(self.id)
    end
end
