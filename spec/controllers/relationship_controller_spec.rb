require 'spec_helper'

describe RelationshipsController do

  describe 'GET index' do

    it_behaves_like "with unauthenticated user" do
      let(:action) { get :index }
    end

    it "renders relationships index template" do
      set_current_user
      get :index
      expect(response).to render_template :index
    end

    it "gets the people current_user is following" do
      bob = set_current_user
      san = Fabricate(:user, email_address: 'san@san.com')
      kiran = Fabricate(:user, email_address: 'kiran@skiran.com')
      sue = Fabricate(:user, email_address: 'sue@sue.com')
      Fabricate(:relationship, follower: bob, leader: san)
      Fabricate(:relationship, follower: bob, leader: kiran)
      Fabricate(:relationship, follower: bob, leader: sue)
      get :index
      expect(assigns(:followings)).to eq(bob.following_rels)
    end
  end

  describe 'POST create' do

    it_behaves_like "with unauthenticated user" do
      let(:action) { post :create, id: 1 }
    end

    before { set_current_user }

    it "redirects to people path" do
      san = Fabricate(:user, email_address: 'san@san.com')
      post :create, leader_id: san.id
      expect(response).to redirect_to people_path
    end

    it "create a following relationship for given user" do
      san = Fabricate(:user, email_address: 'san@san.com')
      post :create, leader_id: san.id
      expect(current_user.following_rels.count).to eq(1)
      expect(current_user.following_rels.first.leader).to eq(san)
    end
 
    it "ensure following relationship not created for current user" do
      post :create, leader_id: current_user.id
      expect(current_user.following_rels.count).to eq(0)
    end

    it "ensure following relationship for given user not created twice " do
      san = Fabricate(:user, email_address: 'san@san.com')
      post :create, leader_id: san.id
      post :create, leader_id: san.id
      expect(current_user.following_rels.count).to eq(1)
    end
  end
 
   describe 'DELETE destroy' do

    it_behaves_like "with unauthenticated user" do
      let(:action) { delete :destroy, id: 1 }
    end

    before { set_current_user }

    it "redirects to people path" do
      san = Fabricate(:user, email_address: 'san@san.com')
      rel = Fabricate(:relationship, follower: current_user, leader: san)
      delete :destroy, id: rel.id
      expect(response).to redirect_to people_path
    end

    it "delete a following relationship for given user" do
      san = Fabricate(:user, email_address: 'san@san.com')
      rel = Fabricate(:relationship, follower: current_user, leader: san)
      delete :destroy, id: rel.id
      expect(current_user.following_rels.count).to eq(0)
    end
 
    it "ensure following relationship not deleted for user other than current" do
      san = Fabricate(:user, email_address: 'san@san.com')
      bob = Fabricate(:user, email_address: 'bob@bob.com')
      rel1 = Fabricate(:relationship, follower: current_user, leader: san)
      rel2 = Fabricate(:relationship, follower: bob, leader: san)
      delete :destroy, id: rel2.id
      expect(bob.following_rels.count).to eq(1)
    end

  end
  
end