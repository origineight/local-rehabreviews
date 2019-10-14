class Category < ActiveRecord::Base
  
  has_many :category_links, dependent: :destroy
  has_many :listings, :through => :category_links
  
  extend FriendlyId
  friendly_id :name, use: :slugged

  def self.directory_sorted(directory_id)
    if directory_id == 'mental-health'
      where(:id => [173, 175, 178, 179, 192, 193, 194, 195, 196, 197, 202, 201, 203, 205, 223, 224, 225, 226, 227, 228, 229, 239, 174, 180, 171, 206, 207, 208, 209, 211, 212, 213, 215, 216, 217, 218, 219, 220, 221, 222, 278, 507])
    elsif directory_id == 'rehabs'
      where(:id => [163, 164, 165, 173, 175, 176, 61, 64, 65, 178, 179, 172, 174, 58, 59, 60, 62, 63, 177, 180, 167, 169, 170, 171, 182, 184, 185, 188, 189, 191, 168, 506, 181, 183, 186, 187, 190, 507])
    elsif directory_id == 'pain-management'
      where(:id => [125, 126, 127, 135, 136, 137, 138, 140, 141, 143, 146, 147, 148, 149, 150, 151, 152, 154, 156, 158, 159, 160, 161, 162, 507])
    elsif directory_id == 'buprenorphine'
      where(:id => nil)
    else
      where(:id => nil)
    end
  end

  def self.boostable
    where(:boostable => true)
  end

end