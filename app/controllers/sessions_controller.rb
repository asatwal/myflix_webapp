class SessionsController < ApplicationController

  def new
    redirect_to root_path if current_user
  end

  def create

    @user = User.find_by(email_address: params[:email_address])

    if @user && @user.authenticate(params[:password])
      if @user.active
        session[:user_id] = @user.id
        redirect_to root_path, notice: 'You have successfully signed in'
      else
        flash[:danger] = "Your account has been suspended. Please contact customer services."
        render :new     
      end
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