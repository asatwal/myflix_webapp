class ResetPasswordsController < ApplicationController

  def show

    user = User.find_by(token: params[:id])

    if user
      @token = params[:id]
    else
      redirect_to invalid_token_path 
    end

  end


  def create
    user = User.find_by(token: params[:token])

    if user
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      user.generate_token

      if user.save
        redirect_to sign_in_path, notice: 'Your password has been reset. Please sign in'
        return
      else
        flash[:danger] = user.errors.full_messages.join('. ')
        @token = params[:token]
        render :show
      end

    else
      redirect_to invalid_token_path 
    end
    
  end

end