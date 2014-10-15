require 'spec_helper'

describe ResetPasswordsController  do

  describe "GET show" do

    let(:bill) {Fabricate(:user)}

    it "renders show template for valid user token" do
      get :show, id: bill.token
      expect(response).to render_template :show
    end

    it "sets @token for valid user token" do
      get :show, id: bill.token
      expect(assigns(:token)).to eq(bill.token)
    end

    it "redirects to invalid token path for invalid user token" do
      get :show, id: '12345678'
      expect(response).to redirect_to invalid_token_path
    end

  end

  describe "POST create" do

    let(:bill) {Fabricate(:user)}

    context "Invalid inputs" do

      it "redirects to invalid token path for invalid user token" do
        bill.password = 'newpassword'
        bill.password_confirmation = 'newpassword'
        post :create, token: '12345678', password: bill.password, password_confirmation: bill.password_confirmation
        expect(response).to redirect_to invalid_token_path
      end

      it "set flash error message on invalid password confirmation" do
        bill.password = 'newpassword'
        bill.password_confirmation = 'oldpassword'
        post :create, token: bill.token, password: bill.password, password_confirmation: bill.password_confirmation
        expect(flash[:danger]).to be_present
      end

      it "sets @token on invalid password confirmation" do
        bill.password = 'newpassword'
        bill.password_confirmation = 'oldpassword'
        post :create, token: bill.token, password: bill.password, password_confirmation: bill.password_confirmation
        expect(assigns(:token)).to eq(bill.token)
      end

      it "renders show template on invalid password confirmation" do
        bill.password = 'newpassword'
        bill.password_confirmation = 'oldpassword'
        post :create, token: bill.token, password: bill.password, password_confirmation: bill.password_confirmation
        expect(response).to render_template :show
      end
    end


    context "Valid inputs" do

      it "redirects to sign in path" do
        bill.password = 'newpassword'
        bill.password_confirmation = 'newpassword'
        post :create, token: bill.token, password: bill.password, password_confirmation: bill.password_confirmation
        expect(response).to redirect_to sign_in_path
      end

      it "sets success notice" do
        bill.password = 'newpassword'
        bill.password_confirmation = 'newpassword'
        post :create, token: bill.token, password: bill.password, password_confirmation: bill.password_confirmation
        expect(flash[:notice]).to be_present
      end

    end

  end

end