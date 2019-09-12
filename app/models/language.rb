class Language < ActiveRecord::Base
  has_and_belongs_to_many :listings

  extend FriendlyId
  friendly_id :name, use: :slugged

end
