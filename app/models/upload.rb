class Upload < ActiveRecord::Base
  belongs_to :listing

  has_attached_file :image,
    :styles => {
      :mini => "100x70#",
      :featured_thumb => "190x140#",
      :thumb => "168x141#",
      :backend => "400x266>",
      :profile => "720x480>"
    },
    :convert_options => {
      :backend => "-background white -gravity center -extent 400x266",
      :profile => "-background white -gravity center -extent 720x480"
    },
    :s3_protocol => 'https'
    
  validates_attachment :image, :presence => true,
    :content_type => { :content_type => ["image/jpeg", "image/png"] },
    :size => { :in => 0..5.megabytes }

  validates_associated :listing

end