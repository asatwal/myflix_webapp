class AppMailer < ActionMailer::Base

  def register_email user

    @user = user

    mail from: 'myflix@e-eworx.co.uk', to: user.email_address, subject: 'Welcome to MyFlix'
    
  end

  def forgot_password_email user

    @user = user

    mail from: 'myflix@e-eworx.co.uk', to: user.email_address, subject: 'Reset Password'
    
  end
end