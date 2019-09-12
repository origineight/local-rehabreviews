class Rating < ActiveRecord::Base
  include Rakismet::Model
  rakismet_attrs :author => :title, :content => :body

  belongs_to :listing, touch: true
  has_many :comments
  accepts_nested_attributes_for :comments, reject_if: :all_blank, allow_destroy: true
  validates :initials, presence: true, length: { maximum: 5 }
  validates :title, length: { maximum: 100 }
  validates_inclusion_of :score, :in => 0..5, :allow_nil => true, :message => "must be between one and five stars"
  validates :score, presence: true
  validates :attended, :acceptance => {:accept => true, :message => "confirmation must be checked"}
  scope :approved, -> { where(approval: 'yes') }
  scope :declined, -> { where(approval: 'no') }
  scope :pending, -> { where(approval: nil) }

  after_create :send_notifications

  def send_notifications
    AdminMailer.new_rating(self).deliver
  end

end
