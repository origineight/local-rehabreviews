class Admin::CitiesController < ApplicationController
  before_filter :authenticate_member!
  before_filter :admin_member
  before_filter :obtain_city, only: [:edit, :update, :destroy]

  def index
    @cities = City.includes(:state).page(params[:page]).per(100)
  end

  def new
    @city = City.new
    @states = State.all
  end

  def create
    @city = City.new(city_params)
    if @city.save
      redirect_to edit_admin_city_path(@city)
    else
      @states = State.all
      render 'new'
    end
  end

  def edit
    @states = State.all
  end

  def update
    if @city.update(city_params)
      redirect_to edit_admin_city_path(@city)
    else
      render 'edit'
    end
  end

  def destroy
    @city.destroy
    redirect_to admin_cities_path
  end

  def search
    search_param = params[:q]
    search_param = search_param.downcase
    @cities = City.where("lower(name) = ?",search_param).page(params[:page]).per(100)
  end

  private
  def obtain_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit(:name, :state_id)
  end

  def admin_member
    redirect_to :root unless current_member.is_administrator?
  end
end
