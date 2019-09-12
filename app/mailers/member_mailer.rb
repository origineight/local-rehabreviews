class MemberMailer < ActionMailer::Base

  default from: "Rehab Reviews <contact@rehabreviews.com>"

  def new_member(member)
    @member = member
    mail(to: "#{member.first_name} #{member.last_name} <#{member.email}>", subject: "Welcome to Rehab Reviews" )
  end

  def approved_claim(claim)
    @claim = claim
    mail(to: "#{claim.member.first_name} #{claim.member.last_name} <#{claim.member.email}>", subject: "Your Claim ##{claim.id.to_s} was Approved on Rehab Reviews" )
  end

  def declined_claim(claim)
    @claim = claim
    mail(to: "#{claim.member.first_name} #{claim.member.last_name} <#{claim.member.email}>", subject: "Your Claim ##{claim.id.to_s} was Declined on Rehab Reviews" )
  end

end
