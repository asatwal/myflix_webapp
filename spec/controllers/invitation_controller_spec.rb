require 'spec_helper'

describe InvitationsController do 

  describe 'GET new' do

    it_behaves_like "with unauthenticated user" do
      let(:action) { get :new }
    end

    it 'sets @invitation' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end
  
  describe 'POST create' do

    it_behaves_like "with unauthenticated user" do
      let(:action) { get :new }
    end

    context "with authenicated user" do

      before {set_current_user}
      after {ActionMailer::Base.deliveries.clear}

      let (:attrs) {Fabricate.attributes_for(:invitation)}

      it 'renders new template on validation error' do
        post :create, invitation: { email_address: '', full_name: '', message: '' }
        expect(response).to render_template :new     
      end

      it 'set errors in @invitation on validation error' do
        post :create, invitation: { email_address: '', full_name: '', message: '' }
        expect(assigns(:invitation).errors.size).to be > 0
      end

      it 'does not send email on validation error' do
        post :create, invitation: { email_address: '', full_name: '', message: '' }
        expect(ActionMailer::Base.deliveries.size).to eq(0)
      end

      it 'sets the inviter user id in the invitation' do
        post :create, invitation: attrs
        message = ActionMailer::Base.deliveries.last
        expect(assigns(:invitation).inviter_id).to eq current_user.id
      end

      it 'sends email on successful invitation' do
        post :create, invitation: attrs
        message = ActionMailer::Base.deliveries.last
        message.to.should eq [ attrs[:email_address] ]
      end

      it 'sets flash message on successful invitation' do
        post :create, invitation: attrs
        expect(flash[:notice]).to be_present
      end

      it 'redirects to new invitation path on successful invitation' do
        post :create, invitation: attrs
        expect(response).to redirect_to new_invitation_path
      end
    end
  end

end