class Admin::BenefitsCheckNotificationsController < ApplicationController
  before_filter :authenticate_member!, :require_admin
  before_filter :find_benefits_check_notification, only: [:edit, :update, :destroy]

  def index
    @ibcns = BenefitsCheckNotification.order(created_at: :desc).page(params[:page]).per(100)
  end

  def new
    @ibcn = BenefitsCheckNotification.new 
  end

  def create
    @ibcn = BenefitsCheckNotification.new(benefits_check_notifications_params)
    if @ibcn.save
      redirect_to :admin_benefits_check_notifications, notice: 'Notification created successfully'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @ibcn.assign_attributes(benefits_check_notifications_params)
    if @ibcn.save
      redirect_to :admin_benefits_check_notifications, notice: 'Notification updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @ibcn.destroy
    redirect_to :admin_benefits_check_notifications, notice: 'Notification removed successfully'
  end

  private
    def find_benefits_check_notification
      @ibcn = BenefitsCheckNotification.find(params[:id])
    end

    def benefits_check_notifications_params
      params[:benefits_check_notification][:insurance_types].delete("")
      params.require(:benefits_check_notification).permit(:subject, :content, :submitted_from, :submitted_to, insurance_types: [])
    end
end
