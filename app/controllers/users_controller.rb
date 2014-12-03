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

    result = UserSignup.new(@user).sign_up params[:stripeToken], params[:invitation_token]

    if result.success?

      # Save user to session as this indicates user logged in
      session[:user_id] = result.user_id

      flash[:notice] = result.message
      redirect_to root_path
    else
      flash[:danger] = result.message
      render :new
    end
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

end