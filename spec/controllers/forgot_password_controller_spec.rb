require 'spec_helper'

describe ForgotPasswordsController  do

  describe "POST create" do

      after {ActionMailer::Base.deliveries.clear}

      context "blank inputs " do

        it "sets error message" do
          post :create, email_address: ''
          expect(flash[:danger]).to eq("Email address cannot be blank")
        end

        it "redirects to new forgot passwords path" do
          post :create, email_address: ''
          expect(response).to redirect_to new_forgot_password_path
        end

        it "does not send email" do
          post :create, email_address: ''
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end

      end


      context "user exists" do

        let(:user) {Fabricate(:user)}

        it "sends reset password email to user" do
          post :create, email_address: user.email_address
          message = ActionMailer::Base.deliveries.last
          message.to.should eq [user.email_address] 
        end


        it "redirects to confirm password reset path" do
          post :create, email_address: user.email_address
          expect(response).to redirect_to confirm_password_reset_path
        end

      end

      context "user does not exist" do

        it "sets error message" do
          post :create, email_address: 'random@email.com'
          expect(flash[:danger]).to eq("That user is not known on the system")
        end


        it "redirects to new forgot passwords path" do
          post :create, email_address: 'random@email.com'
          expect(response).to redirect_to new_forgot_password_path
        end

        it "does not send email" do
          post :create, email_address: 'random@email.com'
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end

      end
  end

end