class Claim < ActiveRecord::Base

  belongs_to :member
  belongs_to :listing

  scope :approved, -> { where(approved: 'yes') }
  scope :pending, -> { where(approved: nil) }
  scope :declined, -> { where(approved: 'no') }

  validates_uniqueness_of :member_id, :scope => :listing_id, :message => "You have already submitted a claim for this listing"
  validates_uniqueness_of :listing_id, :scope => :member_id, :message => "You have already submitted a claim for this listing"
  validates :name, presence: true, length: {maximum: 100}
  validates_presence_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_presence_of :phone

  after_create :send_notifications

  def send_notifications
    if self.listing.published?
      AdminMailer.new_claim(self).deliver
    else
      AdminMailer.new_listing(self).deliver
    end
  end


end
