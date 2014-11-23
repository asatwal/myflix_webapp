require 'spec_helper'

describe UsersController do


  let(:invitation) {Fabricate(:invitation, inviter: Fabricate(:user))}

  let(:token) {'1234560'}

  describe "GET new" do

    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it "redirects to root_path for authenticated user" do
      set_current_user
      get :new
      expect(response).to redirect_to root_path     
    end

    it "renders new template for unauthenticated user" do
      get :new
      expect(response).to render_template :new
    end

  end

  describe "GET new_invited" do

    it "redirects to root_path for authenticated user" do
      set_current_user
      get :new_invited, token: 'xxx'
      expect(response).to redirect_to root_path     
    end

    it "finds invitee with token" do
      get :new_invited, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "renders new template for invitee with token" do
      get :new_invited, token: invitation.token
      expect(response).to render_template :new     
    end

    it "pre fills email for invitee with token" do
      get :new_invited, token: invitation.token
      expect(assigns(:user).email_address).to eq(invitation.email_address)
    end

    it "redirects to link expired page for invalid token" do
      get :new_invited, token: 'xxx'
      expect(response).to redirect_to invalid_token_path     
    end

  end

  describe "POST create" do
    
    context "with valid inputs and valid payment info" do

      before do
        charge = double(:charge, success?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "creates user" do
        user_attrs = Fabricate.attributes_for(:user)
        post :create, user: user_attrs, stripeToken: token
        expect(assigns(:user)).to eq(User.find_by(email_address: user_attrs[:email_address]))
      end

      it "redirects to root_path" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: token
        expect(response).to redirect_to root_path    
      end

      it "sets user_id in session" do
        user_attrs = Fabricate.attributes_for(:user)
        post :create, user: user_attrs, stripeToken: token
        expect(session[:user_id]).to eq(User.find_by(email_address: user_attrs[:email_address]).id)
      end

      it "sets the inviter as follower of invitee if token exists" do
        user_attrs = Fabricate.attributes_for(:user, email_address: invitation.email_address)
        post :create, user: user_attrs, invitation_token: invitation.token, stripeToken: token
        expect(invitation.inviter.follows?assigns(:user)).to be true
      end

      it "sets the invitee as follower of inviter if token exists" do
        user_attrs = Fabricate.attributes_for(:user, email_address: invitation.email_address)
        post :create, user: user_attrs, invitation_token: invitation.token, stripeToken: token
        expect(assigns(:user).follows?invitation.inviter).to be true
      end

      it "clears invitation token" do
        user_attrs = Fabricate.attributes_for(:user, email_address: invitation.email_address)
        post :create, user: user_attrs, invitation_token: invitation.token, stripeToken: token
        expect(Invitation.find_by(email_address: invitation.email_address).token).to be_nil
      end
    end

    context "with valid inputs and invalid payment details" do

      before do
        charge = double(:charge, success?: false, error_message: 'Your card was declined')
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      let(:user_attrs) {Fabricate.attributes_for(:user)}

      it "does not create a new user record" do
        post :create, user: user_attrs, stripeToken: token
        expect(User.count).to eq(0)
      end

      it "redirects users/new template" do
        post :create, user: user_attrs, stripeToken: token
        expect(response).to render_template :new 
      end

      it "sets flash message to invalid card payment message" do
        post :create, user: user_attrs, stripeToken: token
        expect(flash[:danger]).to eq('Your card was declined')
      end

    end

    context "with invalid inputs and valid payment details" do

      let(:user) {Fabricate.build(:user)}

      it "sets @user (no password confirmation)" do
        post :create, user: {email_address: user.email_address, 
                             password: user.password, 
                             password_confirmation: 'xx', 
                             full_name: user.full_name}
        expect(assigns(:user)).to be_instance_of(User)  
      end

      it "does not create user (full name missing)" do
        post :create, user: {email_address: user.email_address, 
                             password: user.password, 
                             password_confirmation: user.password}
        expect(User.find_by(email_address: user.email_address)).to eq(nil)    
      end

      it "renders users/new template (email missing)" do
        post :create, user: {password: user.password, 
                             password_confirmation: user.password, 
                             full_name: user.full_name}
        expect(response).to render_template :new     
      end

      it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: {email_address: user.email_address, 
                             password: user.password, 
                             password_confirmation: user.password}
      end

      it "sets flash message to say card has not been charged" do
        post :create, user: {password: user.password, 
                             password_confirmation: user.password, 
                             full_name: user.full_name}
        expect(flash[:notice]).to eq('Your credit card has not been charged')
      end
    end
  end


  describe "GET show" do
    let(:bob) {Fabricate(:user, email_address: "bob@bob.com")}

    it "sets @user for authenticated user" do
      set_current_user
      get :show, id: bob.id
      expect(assigns(:user)).to eq(bob)
    end

    it "redirects to root_path for unauthenticated user" do
      get :show, id: bob.id
      expect(response).to redirect_to front_path     
    end
  end

  describe "SEND email on new user" do

    before do
      charge = double(:charge, success?: true)
      StripeWrapper::Charge.should_receive(:create).and_return(charge)
    end

    # As the mail sending is not part os the database transaction 
    # it is not cleared from database

    after {ActionMailer::Base.deliveries.clear}

    it "sends email" do
      user_attrs = Fabricate.attributes_for(:user)
      post :create, user: user_attrs, stripeToken: token
      ActionMailer::Base.deliveries.should_not be_empty
    end

    it "sends email to correct recipient" do
      user_attrs = Fabricate.attributes_for(:user)
      post :create, user: user_attrs, stripeToken: token
      message = ActionMailer::Base.deliveries.last
      message.to.should eq [user_attrs[:email_address]] 
    end

    it "sends email with correct Subject" do
      user_attrs = Fabricate.attributes_for(:user)
      post :create, user: user_attrs, stripeToken: token
      message = ActionMailer::Base.deliveries.last
      message.subject.should eq "Welcome to MyFlix" 
    end

    it "sends email with correct content" do
      user_attrs = Fabricate.attributes_for(:user)
      post :create, user: user_attrs, stripeToken: token
      message = ActionMailer::Base.deliveries.last
      message.body.should include user_attrs[:full_name] 
    end


  end

  describe "SEND email on new user with invalid input" do

    before {ActionMailer::Base.deliveries.clear}

    it "does not send email on invalid input" do
      user_attrs = Fabricate.attributes_for(:user)
      post :create, user: {email_address: 'bob@email.com'}, stripeToken: token
      ActionMailer::Base.deliveries.should be_empty
    end
  end

end

