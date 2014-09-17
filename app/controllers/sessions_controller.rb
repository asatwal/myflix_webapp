class SessionsController < ApplicationController

  layout "application"

  def new
    redirect_to root_path if current_user
  end

  def create

    @user = User.find_by(email_address: params[:email_address])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'You have successful signed in'
    else
      flash[:danger] = "Incorrect Username or Password" 
      render :new     
    end
    
  end

  def destroy
    session[:user_id] = nil

    redirect_to front_path, notice: 'You have now signed out'
  end

end