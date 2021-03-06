require 'spec_helper'

describe UserSignup do

  describe "#sign_up" do 

    let(:invitation) {Fabricate(:invitation, inviter: Fabricate(:user))}
    let(:stripe_token) {'1234560'}
    let(:customer_payment_token) {'1234abcd'}
    let(:user) {Fabricate.build(:user, email_address: 'user_signup@user.com')}

    context "with valid inputs and valid payment info" do

      before do
        customer = double(:customer, success?: true, payment_token: customer_payment_token)
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end

      it "creates user" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(User.count).to eq(2)
      end

      it "result returns success" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(result.success?).to be_truthy
      end

      it "sets the inviter as follower of invitee if token exists" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(invitation.inviter.follows?user).to be true
      end

      it "sets the invitee as follower of inviter if token exists" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(user.follows?invitation.inviter).to be true
      end

      it "clears invitation token" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(Invitation.find_by(email_address: invitation.email_address).token).to be_nil
      end

      it "stores the payment token from stripe" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(User.last.payment_token).to eq(customer_payment_token)
      end

    end

    context "with valid inputs and invalid payment details" do

      before do
        customer = double(:customer, success?: false, error_message: 'Your card was declined')
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end

      it "sets flash message to invalid card payment message" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(result.message).to eq('Your card was declined')
      end

      it "result returns error" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(result.success?).to be_falsey
      end

      it "does not create user" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(User.count).to eq(1)    
      end
    end


    context "with invalid inputs and valid payment details" do

      before do
        expect(StripeWrapper::Customer).to_not receive(:create)
      end

      it "result returns error (no password confirmation)" do
        user = Fabricate.build(:user, 
                                email_address: 'user_signup@user.com',
                                password_confirmation: 'xx')

        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(result.success?).to be_falsey
      end

      it "does not create user (full name missing)" do
        user = Fabricate.build(:user, 
                                email_address: 'user_signup@user.com',
                                full_name: '')
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(User.count).to eq(1)    
      end

      it "sets flash message to say user details invalid and card not charged" do
        user = Fabricate.build(:user, 
                                email_address: 'user_signup@user.com',
                                full_name: '')
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        expect(result.message).to eq('User details are invalid. Your credit card has not been charged.')
      end
    end

    describe "SEND email on new user" do

      before do
        customer = double(:customer, success?: true, payment_token: customer_payment_token)
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
      end

      # As the mail sending is not part os the database transaction 
      # it is not cleared from database

      after {ActionMailer::Base.deliveries.clear}

      it "sends email" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        ActionMailer::Base.deliveries.should_not be_empty
      end

      it "sends email to correct recipient" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        message = ActionMailer::Base.deliveries.last
        message.to.should eq [user.email_address]
      end

      it "sends email with correct Subject" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        message = ActionMailer::Base.deliveries.last
        message.subject.should eq "Welcome to MyFlix" 
      end

      it "sends email with correct content" do
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        message = ActionMailer::Base.deliveries.last
        message.body.should include user.full_name 
      end
    end

    describe "Does NOT SEND email on new user with invalid input" do

      before do
        expect(StripeWrapper::Customer).to_not receive(:create)
        ActionMailer::Base.deliveries.clear
      end

      it "does not send email on invalid input" do
        user = Fabricate.build(:user, 
                                email_address: 'user_signup@user.com',
                                password_confirmation: 'xx')
        result = UserSignup.new(user).sign_up stripe_token, invitation.token
        ActionMailer::Base.deliveries.should be_empty
      end
    end

  end
end