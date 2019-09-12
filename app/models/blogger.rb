class Blogger < ActiveRecord::Base
  # External resources
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :posts, as: :creator

  # Validations
  validates :full_name, presence: true
end
