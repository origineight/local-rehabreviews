class MembersController < ApplicationController
  before_filter :authenticate_member!
  before_filter :admin_member, :only => [:admin, :listings, :claims, :ratings, :profile, :destroy]

  def dashboard
    if current_member.is_administrator?
      redirect_to :admin_dashboard
    end
    @claims = current_member.claims.pending.includes(:listing).page(params[:page]).per(100)
    @listings = current_member.listings.approved.includes(:directory, :city).page(params[:page]).per(100)
  end

  def admin
    @claims = Claim.includes(:member, listing: :directory).pending
    @claims = @claims.page(params[:page]).per(100) if @claims.present?
    @ratings = Rating.includes(listing: :directory).pending
    @ratings = @ratings.page(params[:page]).per(100) if @ratings.present?
  end

  def listings
    @listings = Listing.order(created_at: :desc).page(params[:page]).per(100)
  end

  def admin_search
    @listings = Listing.search(params[:q], size: 200).records.page(params[:page]).per(100)
  end

  def profile
    @member = Member.includes(listings: :directory).find(params[:id])
  end

  def claims
    @claims = Claim.includes(:member, listing: :directory).page(params[:page]).per(100)
  end

  def ratings
     @ratings = Rating.all.includes(listing: :directory).order("created_at DESC").page(params[:page]).per(100)
  end

  def members
    # TODO: fix n +1 query listings: :claims
    @members = Member.page(params[:page]).per(100)
  end

  def destroy
    member = Member.find(params[:id])
    member.destroy
    redirect_to :admin_dashboard, notice: 'Member removed successfully'
  end

  def upgrade_manager
    @upgrades = current_member.upgrades
  end

  def payment_history
    @payments = current_member.payments.where(:status => "Completed")
  end

  private

    def admin_member
      redirect_to :root unless current_member.is_administrator?
    end

end
