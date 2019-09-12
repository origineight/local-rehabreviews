class Directory < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :listings
  has_many :categories, through: :listings

  def initials
    name.split.map(&:first).join.upcase
  end
end
