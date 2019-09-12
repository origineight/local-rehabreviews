class UploadsController < ApplicationController
  respond_to :html, :js

  def new
    @listing = Listing.friendly.find(params[:listing_id])
    @upload = Upload.new
  end

  def create
    @listing = Listing.friendly.find(params[:listing_id])
    @upload = @listing.uploads.create(upload_params)
    if @upload.save
      redirect_to edit_listing_path(@listing), :flash => { :success => "Image uploaded successfully" }
    else
      redirect_to edit_listing_path(@listing), :flash => { :danger => "Image is invalid." }
    end
  end

  def destroy
    @listing = Listing.friendly.find(params[:listing_id])
    @upload = Upload.find(params[:id])
    @upload.destroy
    redirect_to edit_listing_path(@listing), :flash => { :success => "Image removed successfully." }
  end

  private

    def upload_params
      params.require(:upload).permit(:image, :listing_id)
    end

end
