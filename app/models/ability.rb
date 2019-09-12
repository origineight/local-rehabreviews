class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Member.new

    # Everybody can read listings
    can :read, Listing do |l|
      l.published?
    end

    if user.is_a?(Member)
      # Rules for members
      if user.is_administrator?
        can :manage, :all
      end
      can :manage, Listing do |l|
        l.members.approved.include? user
      end
    elsif user.is_a?(Blogger)
      # Rules for bloggers
      can :manage, Post
    end
  end
end
