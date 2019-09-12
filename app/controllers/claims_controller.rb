class ClaimsController < ApplicationController
  before_filter :authenticate_member!
  before_filter :admin_member, :only => [:approve, :decline, :destroy]
  
  def new
    @claim = Claim.new
    @listing = Listing.friendly.find(params[:listing_id])
  end

  def create
    @claim = Claim.create(claim_params)
    if @claim.save
      redirect_to dashboard_path
    else
      if params[:claim][:listing_id]
        @listing = Listing.find(params[:claim][:listing_id])
      end
      render 'new', :listing_id => @listing.id
    end
  end

  def approve
    @claim = Claim.find(params[:id])
    @claim.approved = 'yes'
    if @claim.save
      redirect_to admin_claims_path
      MemberMailer.approved_claim(@claim).deliver
    end
  end

  def decline
    @claim = Claim.find(params[:id])
    @claim.approved = 'no'
    if @claim.save
      redirect_to admin_claims_path
      MemberMailer.declined_claim(@claim).deliver
    end
  end

  private

    def claim_params
      params.require(:claim).permit(:listing_id, :member_id, :description, :name, :email, :phone)
    end

    def admin_member
      redirect_to root_url unless current_member.is_administrator?
    end

end
