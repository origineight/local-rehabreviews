class Admin::BloggersController < ApplicationController
  before_filter :authenticate_member!, :require_admin
  before_filter :find_blogger, except: [:index, :new, :create]

  def index
    @bloggers = Blogger.page(params[:page]).per(100)
  end

  def new
    @blogger = Blogger.new
  end

  def create
    @blogger = Blogger.new(blogger_params)
    if @blogger.save
      redirect_to :admin_bloggers, notice: 'Blogger created successfully'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @blogger.assign_attributes(blogger_params)
    if @blogger.save
      redirect_to :admin_bloggers, notice: 'Blogger updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @blogger.destroy
    redirect_to :admin_bloggers, notice: 'Blogger removed successfully'
  end

  private
    def find_blogger
       @blogger = Blogger.find(params[:id])
    end

    def blogger_params
      params.require(:blogger).permit(:full_name, :email, :password, :password_confirmation)
    end
end
