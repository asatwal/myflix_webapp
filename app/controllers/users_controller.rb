class UsersController < ApplicationController

  layout "application"

  def new
    redirect_to root_path if current_user

    @user = User.new
    
  end

  def create

    @user = User.new(user_params)

    if @user.save

      flash[:notice] = "New user #{@user.full_name} created"

      # Save user to session as this indicates user logged in
      session[:user_id] = @user.id

      redirect_to root_path
    else
      render :new
    end
    
  end

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :full_name)
  end

end