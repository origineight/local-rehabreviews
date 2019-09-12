class RatingsController < ApplicationController
  respond_to :html, :js
  before_filter :admin_member, :only => [:approve, :decline, :destroy, :edit, :update]

  def add_comment
    @comment = Comment.new(comment_params)
    @comments = @comment.rating.comments
    respond_to do |format|
      format.js { render file: 'ratings/failed_add_comment.js.erb' }
    end unless verify_recaptcha(model: @comment) && @comment.save
  end

  def new
    @rating = Rating.new
    @listing = Listing.friendly.find(params[:listing_id])
    @displayname = @listing.full_name
  end

  def edit
    @rating = Rating.find(params[:id])
    @listing = Listing.friendly.find(params[:listing_id])
    @displayname = @listing.full_name
  end

  def create
    @listing = Listing.find(params[:rating][:listing_id])
    @rating = Rating.new(rating_params)
    # if @rating.spam?
    #   message = "Review has been submitted and is pending approval."
    #   @rating.approval = 'no'
    # else
    message = "Review has been submitted."
    @rating.approval = 'yes'
    # end
    if verify_recaptcha(model: @rating) && @rating.save
      flash[:success] = message
      redirect_to seo_listing_path(@listing)
    else
      render 'new'
    end
  end

  def update
    @rating = Rating.find(params[:id])
    if @rating.update(rating_params)
      flash[:success] = "Review has been updated."
      redirect_to admin_ratings_path
    else
      render 'new'
    end
  end

  def approve
    @rating = Rating.find(params[:id])
    @rating.approval = 'yes'
    @rating.save
    redirect_to admin_dashboard_path
  end

  def decline
    @rating = Rating.find(params[:id])
    @rating.approval = 'no'
    @rating.save
    redirect_to admin_dashboard_path
  end

  private
    def rating_params
      params.require(:rating).permit(:body, :score, :listing_id, :title, :initials, :attended)
    end

    def comment_params
      params.require(:comment).permit(:title, :body, :rating_id, :initial)
    end

    def admin_member
      redirect_to root_url unless current_member.is_administrator?
    end

end
