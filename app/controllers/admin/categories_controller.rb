class Admin::CategoriesController < ApplicationController
  before_filter :authenticate_member!
  before_filter :admin_member
  before_filter :obtain_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.page(params[:page]).per(100)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to edit_admin_category_path(@category)
    else
      render 'new'
    end
  end

  def edit
    
  end

  def update
    if @category.update(category_params)
      redirect_to edit_admin_category_path(@category)
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path
  end

  def search
    search_param = params[:q]
    search_param = search_param.downcase
    @categories = Category.where("lower(name) = ?",search_param).page(params[:page]).per(100)
  end

  private
  def obtain_category
    @category = Category.friendly.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :meta_name, :meta_description, :category_subhead, :boostable)
  end

  def admin_member
    redirect_to :root unless current_member.is_administrator?
  end
end
