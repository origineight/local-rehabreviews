class AdminMailer < ActionMailer::Base
  default from: "Rehab Reviews <contact@rehabreviews.com>"
  default to: ENV['DEFAULT_ADMIN_EMAIL']

  def new_member(member)
    @member = member
    mail(subject: "New Member: #{member.first_name} #{member.last_name}")
  end

  def new_claim(claim)
    @claim = claim
    mail(subject: "Claim ##{claim.id.to_s} Submitted on RehabReviews.com")
  end

  def new_listing(claim)
    @claim = claim
    mail(subject: "New Listing Request - #{claim.listing.full_name}")
  end

  def new_rating(rating)
    @rating = rating
    mail(to: "marypatterson@theafterpartygroup.com, info@cleanandsobermedia.com, editors@cleanandsobermedia.com, kris@cleanandsobermedia.com", subject: "New Rating for #{rating.listing.full_name} Submitted on RehabReviews.com")
  end

end
