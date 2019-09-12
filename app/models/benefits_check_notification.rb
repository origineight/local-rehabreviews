class BenefitsCheckNotification < ActiveRecord::Base

  # Validations
  validates :subject, :content, presence: true
  validates :submitted_from, :submitted_to, timeliness: { type: :time }, allow_blank: true

  # Callbacks
  before_save :format_attributes

  # Methods
  def applicable_to?(benefits_check)
    applicable_by_insurance_type?(benefits_check) && applicable_by_submission_time?(benefits_check)
  end

  private
    def applicable_by_insurance_type?(benefits_check)
      return true if insurance_types.blank?
      insurance_types.include?(benefits_check.insurance_type)
    end

    def applicable_by_submission_time?(benefits_check)
      return true if submitted_from.blank? && submitted_to.blank?
      benefits_check_submitted_at = benefits_check.created_at.strftime('%I:%M')
      if submitted_from? && submitted_to?
        benefits_check_submitted_at.between?(submitted_from, submitted_to)
      elsif submitted_from?
        benefits_check_submitted_at >= submitted_from
      elsif submitted_to?
        benefits_check_submitted_at <= submitted_to
      end
    end

    def format_attributes
      submitted_from.prepend('0') if submitted_from? && submitted_from.length < 5
      submitted_to.prepend('0') if submitted_to? && submitted_to.length < 5
    end
end
