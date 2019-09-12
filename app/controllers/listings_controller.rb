class ListingsController < ApplicationController
  respond_to :html, :js
  before_filter :authenticate_member!, :only => [:new, :edit, :create, :update, :boost, :unboost, :destroy]
  before_filter :admin_member, :only => [:boost, :unboost, :destroy]
  load_and_authorize_resource :except => [:new, :create, :search, :new_redirect, :show], :find_by => :slug
  
  def new
    @listing = Listing.new
    @states = State.includes(:cities).all
    @old_states = old_states_array
    if @listing.city.nil?
      if @states.count > 0
        @cities = @states[0].cities
      else
        @cities = []
      end
    else
      @cities = @listing.city.state.cities
    end
    @languages = Language.all
    @insurances = Insurance.all
    @categories = Category.directory_sorted('rehabs')
    @listing.claims.build
  end

  def create
    @listing = Listing.create(listing_params)
    @states = State.includes(:cities).all
    @old_states = old_states_array
    if @listing.city.nil?
      if @states.count > 0
        @cities = @states[0].cities
      else
        @cities = []
      end
    else
      @cities = @listing.city.state.cities
    end
    @categories = Category.directory_sorted(@listing.directory.slug)
    @languages = Language.all
    @insurances = Insurance.all
    if @listing.save
      if current_member.is_administrator?
        redirect_to edit_listing_path(@listing)
      else
        redirect_to dashboard_path
      end
    else
      render 'new'
    end
  end

  def edit
    @listing = Listing.friendly.find(params[:id])
    @states = State.includes(:cities).all
    @old_states = old_states_array
    if @listing.city.nil?
      if @states.count > 0
        @cities = @states[0].cities
      else
        @cities = []
      end
    else
      @cities = @listing.city.state.cities
    end
    @upload = Upload.new
    @categories = Category.directory_sorted(@listing.directory.slug)
    @languages = Language.all
    @insurances = Insurance.all
  end

  def update
    @listing = Listing.friendly.find(params[:id])
    @states = State.includes(:cities).all
    @old_states = old_states_array
    if @listing.city.nil?
      if @states.count > 0
        @cities = @states[0].cities
      else
        @cities = []
      end
    else
      @cities = @listing.city.state.cities
    end
    @categories = Category.directory_sorted(@listing.directory.slug)
    @languages = Language.all
    @insurances = Insurance.all
    @upload = Upload.new
    if @listing.update(listing_params)
      redirect_to edit_listing_path(@listing)
    else
      render 'edit'
    end
  end

  def show
    @listing = Listing.where(old_slug: params[:id])[0]
    if !@listing.nil?
      duplicate_listing = DuplicateListing.where(listing_associated_id: @listing.id)[0]
      if !duplicate_listing.nil?
        @listing = duplicate_listing.listing
      end
      if @listing.mark_for_deletion
        redirect_to search_directory_path(@listing.directory.slug), status: 301
      else
        redirect_to listing_new_redirect_path(params[:location_data], params[:id])
      end
    else
      @decorator = ListingDecorator.decorate(params)
      @listing = @decorator['object']
      if @listing.phone.blank?
        redirect_to root_url, status: 301
      end
      if @listing.mark_for_deletion
        redirect_to search_directory_path(@listing.directory.slug), status: 301
      else
        @lead = BenefitsCheckLead.new
        GoogleMapsWorker.perform_async(@listing.id) unless @listing.map_image?
        # TODO: Download maps for nearbys and featured listings here?
        # @decorator['nearbys'].each { |nearby| GoogleMapsWorker.perform_async(nearby.id) unless nby.map_image? }
        # @decorator['featured'].each { |featured| GoogleMapsWorker.perform_async(featured.id) unless featured.map_image? }

        fresh_when last_modified: @listing.updated_at
      end
    end
    @custom_services = @listing.custom_service.split(',') rescue nil
  end

  def new_redirect
    @listing = Listing.where(old_slug: params[:id])[0]
    sw = false
    if @listing.nil?
      @listing = Listing.friendly.find(params[:id])
    else
      sw = true
    end

    duplicate_listing = DuplicateListing.where(listing_associated_id: @listing.id)[0]
    sw1 = false
    if !duplicate_listing.nil?
      sw1 = true
      @listing = duplicate_listing.listing
    end
    redirect_to listing_by_directory_location_id_path(@listing.directory.slug, params[:location_data], (sw or sw1) ? @listing.slug : params[:id]), status: 301
  end

  def destroy
    @listing = Listing.friendly.find(params[:id])
    @listing.destroy
    redirect_to admin_listings_path
  end

  def search
    # TODO: Fix n + 1 query :uploads
    @search = SearchDecorator.decorate(params)
    @directories = Directory.all
  end

  def edit_fields_update
    if params[:listing_slug].present?
      @listing = Listing.friendly.find(params[:listing_slug])
    else
      @listing = Listing.new
    end

    @directory = Directory.find(params[:change_directory_type])
    @categories = Category.directory_sorted(@directory.slug)
  end

  def boost
    @listing = Listing.find(params[:listing_id])
    if params[:directory_id]
      @directory = Directory.find(params[:directory_id])
    else
      @directory = @listing.directory
    end
    @categories = Category.directory_sorted(@directory.slug)
    boost = CategoryLink.find_or_create_by(:category_id => params[:category_id], :listing_id => params[:listing_id])
    boost.boosted = true
    boost.save
  end

  def unboost
    @listing = Listing.find(params[:listing_id])
    if params[:directory_id]
      @directory = Directory.find(params[:directory_id])
    else
      @directory = @listing.directory
    end
    @categories = Category.directory_sorted(@directory.slug)
    unboost = CategoryLink.find_by(:category_id => params[:category_id], :listing_id => params[:listing_id])
    unboost.boosted = false
    unboost.save
  end

  def cities_of_state
    state = State.find(params[:state_id])
    @cities = state.cities
    render layout: false
  end

  private

    def listing_params
      params.require(:listing).permit(:name, :first_name, :middle_name, :last_name, :title, :suffix, :address_1, :address_2, :country, :city_id, :old_city, :old_state, :zipcode, :phone, :fax, :website, :facebook, :twitter, :instagram, :description, :meta_description, :custom_description, :additional_data, :listing_slug, :listing_type, :directory_id, :published, :featured, :custom, :state_boost, :paid_advertiser, :mark_for_deletion, :review_url, :custom_service, :category_ids => [], :language_ids => [], :insurance_ids => [], claims_attributes: [:name, :email, :phone, :description, :member_id])
    end

    def admin_member
      redirect_to root_url unless current_member.is_administrator?
    end

    def state_exists?(state)
      all_states[state]
    end

    def state_info(state)
      all_states[state]
    end

    def old_states_array
      temp = []
      all_states.to_a.each do |state|
        temp.push([state[1]["full_state"], state[1]["abbreviation"]])
      end
      temp
    end

end
