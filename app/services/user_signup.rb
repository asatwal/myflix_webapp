class UserSignup

  attr_reader :message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invitation_token)

    if @user.valid?
      charge = StripeWrapper::Charge.create(
        card:        stripe_token,
        amount:      999,
        description: "MyFliX SIgn Up charge for #{@user.email_address}"
        )

      if charge.success?
        @user.save

        AppMailer.register_email(@user).deliver

        @message = "New user #{@user.full_name} created and credit card payment processed."
        @status = :success

        handle_invited_user invitation_token
      else
        @message = charge.error_message
        @status = :error
      end
    else
      @message = "User details are invalid. Your credit card has not been charged."
      @status = :error      
    end

    self
  end

  def user_id
    @user.id
  end

  def success?
    @status == :success
  end

  private

  def handle_invited_user invitation_token
      # Presence of token in parameters indicates an invited user
    if invitation_token.present?

      invitation = Invitation.find_by(token: invitation_token)

      if invitation
        @user.follow invitation.inviter

        invitation.inviter.follow @user

        invitation.update_column(:token, nil)
      end
    end
  end

end