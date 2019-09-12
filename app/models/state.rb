class State < ActiveRecord::Base
  #default_scope
  default_scope{order(name: :asc)}

  #Associations
  has_many :cities

  #Validations
  validates :name, presence: true
end
