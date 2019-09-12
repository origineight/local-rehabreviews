class Admin::MembersController < ApplicationController
  before_filter :authenticate_member!, :require_admin

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to :admin_members, notice: 'Member or admin created successfully'
    else
      render :new
    end
  end

  private
    def member_params
      params.require(:member).permit(:first_name, :last_name, :email, :password, :password_confirmation, :is_administrator)
    end
end
