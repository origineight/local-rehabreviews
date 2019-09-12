class BenefitsCheckLeadsController < ApplicationController

  def new
    @lead = BenefitsCheckLead.new
  end

  def create
    params[:benefits_check_lead][:name] = "#{params[:first_name]} #{params[:last_name]}"
    @lead = BenefitsCheckLead.new(benefits_check_lead_params).tap do |lead|
      lead.referer = request.referer
    end
    @lead.save ? redirect_to(:benefits_check_thanks) : render(:new)
  end

  def thanks
  end

  private
    def benefits_check_lead_params
      params.require(:benefits_check_lead).permit(:name, :phone, :email, :insurance_type, :seeking_help_for, :popup)
    end
end
