class Admin::InsuranceBenefitsChecksController < ApplicationController
  before_filter :authenticate_member!, :require_admin

  def index
    @ibcs = BenefitsCheckLead.order(created_at: :desc).page(params[:page]).per(100)
  end

  def show
    @ibc = BenefitsCheckLead.find(params[:id])
  end

  def destroy
    BenefitsCheckLead.destroy(params[:id])
    redirect_to :admin_insurance_benefits_checks, notice: 'Insurance benefits check removed successfully'
  end
end
