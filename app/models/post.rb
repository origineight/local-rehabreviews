class Post < ActiveRecord::Base

  # External resources definitions
  has_attached_file :image, styles: { fb: '600x315>', tw: '375x435>' }

  # Associations
  belongs_to :creator, polymorphic: true

  #default_scope
  default_scope{where(published: true)}

  # Validations
  validates :creator, :description, :meta_description, :content, presence: true
  validates_attachment :image, content_type: { content_type: ['image/jpeg', 'image/png'] }, size: { in: 0..1.megabytes }, file_name: { matches: [/(png|PNG)\Z/, /(jpe?g|JPE?G)\Z/] }

  #Callbacks
  before_create :set_before_create_attributes

  # Methods
  def author_name
    self.author? ? self.author : self.creator.full_name
  end

  def to_param
    "#{self.id}-#{self.title.parameterize}"
  end

  private
  def set_before_create_attributes
    self.published = false
    nil
  end
end
