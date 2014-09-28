require 'spec_helper'

describe SessionsController do

  describe "GET new" do

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

    context "with correct valid user inputs" do
      let(:current_user) { Fabricate(:user) }

      before do
        post :create, email_address: current_user.email_address, password: current_user.password
      end

      it "sets user_id in session" do
        expect(session[:user_id]).to eq(current_user.id) 
      end

      it "redirects to root_path" do
        expect(response).to redirect_to root_path     
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank 
      end
    end

    context "with correct invalid user inputs" do
      let(:current_user) { Fabricate(:user) }

      before do
        post :create, email_address: current_user.email_address, password: Faker::Internet.password
      end

      it "user_id in session is nil" do
       expect(session[:user_id]).to be_nil 
      end


      it "redirects to sign_in_path" do
        expect(response).to render_template :new   
      end

      it "sets the danger notice" do
        expect(flash[:danger]).not_to be_blank 
      end
    end


    it "redirects to sign_in_path for non-existent user" do
      post :create, email_address: Faker::Internet.email
      expect(response).to render_template :new    
    end

  end


  describe "GET destroy" do
    before do
      set_current_user
      get :destroy
    end

    it "clears user_id from session" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to front_path" do
      expect(response).to redirect_to front_path     
    end


    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank 
    end

  end


end