class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true, length: {maximum: 40}
  validates :last_name, presence: true, length: {maximum: 40}

  has_many :claims, dependent: :destroy
  has_many :listings, :through => :claims do
    def approved
      where("claims.approved = ?", "yes")
    end
  end
  has_many :posts, as: :creator

  after_create :send_notifications

  def full_name
    full_name = ''
    if self.first_name.present?
      full_name += self.first_name
    end
    if self.last_name.present?
      full_name += ' ' + self.last_name
    end
    full_name
  end

  def send_notifications
    AdminMailer.new_member(self).deliver
    MemberMailer.new_member(self).deliver
  end
end
