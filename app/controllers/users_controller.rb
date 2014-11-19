class UsersController < ApplicationController


  before_action :require_user, only: [:show]
  before_action :ensure_no_user, only: [:new, :new_invited]

  def new
    @user = User.new
  end

  def new_invited

    invitation = Invitation.find_by(token: params[:token])

    if invitation
      @invitation_token = invitation.token
      @user = User.new(email_address: invitation.email_address)
      render :new
    else
      redirect_to invalid_token_path
    end  

  end

  def create

    @user = User.new(user_params)

    if @user.save

      Stripe.api_key = Rails.configuration.stripe[:secret_key]

      charge = Stripe::Charge.create(
        card:        params[:stripeToken],
        amount:      999,
        description: "MyFliX SIgn Up charge for #{@user.email_address}",
        currency:    'gbp'
      )

      AppMailer.register_email(@user).deliver

      flash[:notice] = "New user #{@user.full_name} created and credit card payment processed."

      # Save user to session as this indicates user logged in
      session[:user_id] = @user.id

      handle_invited_user

      redirect_to root_path

    else
      flash[:notice] = "Your credit card has not been charged"
      render :new
    end
    
  rescue Stripe::CardError => e
    flash[:danger] = e.message
    @user.delete
    render :new

  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :full_name)
  end

  def ensure_no_user
    redirect_to root_path if current_user
  end

  def handle_invited_user
    # Presence of token in parameters indicates an invited user
    if params[:invitation_token].present?

      invitation = Invitation.find_by(token: params[:invitation_token])

      if invitation
        @user.follow invitation.inviter

        invitation.inviter.follow @user

        invitation.update_column(:token, nil)
      end
    end
  end

end