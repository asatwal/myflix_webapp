class ForgotPasswordsController < ApplicationController

  def create

    email = params[:email_address]

    if email.blank?

      flash[:danger] = "Email address cannot be blank"

    else
      user = User.find_by(email_address: email)

      if user

        AppMailer.forgot_password_email(user).deliver

        redirect_to confirm_password_reset_path

        return

      else
        flash[:danger] = "That user is not known on the system"
      end

    end

    redirect_to :new_forgot_password

  end

end