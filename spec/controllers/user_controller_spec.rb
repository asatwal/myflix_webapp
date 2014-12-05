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

      let(:user_attrs) {Fabricate.attributes_for(:user)}

      before do
        result = double(:result, success?: true, message: 'New user created and card payment processed', user_id: 1)
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
      end


      it "redirects to root_path" do
        post :create, user: user_attrs, stripeToken: token
        expect(response).to redirect_to root_path    
      end

      it "sets the success flash message" do
        post :create, user: user_attrs, stripeToken: token
        expect(flash[:notice]).to eq('New user created and card payment processed')
      end

      it "sets user_id in session" do
        post :create, user: user_attrs, stripeToken: token
        expect(session[:user_id]).to eq(1)
      end

    end

    context "with valid inputs and invalid payment details" do

      before do
        result = double(:result, success?: false, message: 'Your card was declined')
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
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

      before do
        result = double(:result, success?: false, message: 'User details are invalid.')
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
      end

      let(:user) {Fabricate.build(:user)}

      it "renders users/new template (email missing)" do
        post :create, user: {password: user.password, 
                             password_confirmation: user.password, 
                             full_name: user.full_name}
        expect(response).to render_template :new     
      end

      it "sets flash message to say User details invalid" do
        post :create, user: {password: user.password, 
                             password_confirmation: user.password, 
                             full_name: user.full_name}
        expect(flash[:danger]).to eq('User details are invalid.')
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


end

