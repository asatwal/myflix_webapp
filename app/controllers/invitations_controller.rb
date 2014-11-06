class InvitationsController < ApplicationController

  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create

    @invitation = Invitation.new(invitation_params)
    @invitation.inviter = current_user

    if !@invitation.save
      render :new
    else
      AppMailer.invitation_email(@invitation).deliver
      flash[:notice] = "Invitation email has been sent to #{@invitation.full_name}"
      redirect_to new_invitation_path
    end
    
  end

  def invitation_params
    params.require(:invitation).permit(:email_address, :full_name, :message)
  end

end