require 'spec_helper'

describe UsersController do

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

  describe "POST create" do
    
    context "with valid inputs" do

      it "creates user" do
        user_attrs = Fabricate.attributes_for(:user)
        post :create, user: user_attrs
        expect(assigns(:user)).to eq(User.find_by(email_address: user_attrs[:email_address]))
      end

      it "redirects to root_path" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to root_path    
      end

      it "sets user_id in session" do
        user_attrs = Fabricate.attributes_for(:user)
        post :create, user: user_attrs
        expect(session[:user_id]).to eq(User.find_by(email_address: user_attrs[:email_address]).id)
      end
    end

    context "with invalid inputs" do

      it "sets @user (no password confirmation)" do
        user = Fabricate.build(:user)
        post :create, user: {email_address: user.email_address, password: user.password, full_name: user.full_name}
        expect(assigns(:user)).to be_instance_of(User)  
      end

      it "user not created (full name missing)" do
        user = Fabricate.build(:user)
        post :create, user: {email_address: user.email_address, password: user.password, password_confirmation: user.password}
        expect(User.find_by(email_address: user.email_address)).to eq(nil)    
      end

      it "renders users/new template (email missing)" do
        user = Fabricate.build(:user)
        post :create, user: {password: user.password, password_confirmation: user.password, full_name: user.full_name}
        expect(response).to render_template :new     
      end
    end
  end
end