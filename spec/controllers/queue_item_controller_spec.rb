require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do

    context "with authenticated user" do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
       
      end

      it "retrieves empty @queue_item when no queue items" do
        get :index
        expect(assigns(:queue_items)).to be_empty
      end

      it "retrieves @queue_item array for all items" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item_1,queue_item_2])
      end
    end

    context "with unauthenticated user" do

      it "redirects to front path" do
        get :index
        expect(response).to redirect_to front_path
      end
    end
  end

  describe "POST Create" do
      let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
      end

      it "sets the danger notice on invalid input" do
        post :create
        expect(flash[:danger]).not_to be_blank 
      end

      it "retrieves single @queue_item newly created" do
        post :create, video_id: video.id
        expect(assigns(:queue_items).size).to eq(1)
      end

      it "does not allow @queue_item to be created with identical video" do
        post :create, video_id: video.id
        post :create, video_id: video.id
        expect(assigns(:queue_items).size).to eq(1)
        expect(flash[:danger]).not_to be_blank 
      end

      it "@queue_item added is associated to current user" do
        post :create, video_id: video.id
        expect(assigns(:queue_items).first.user_id).to eq(current_user.id)
      end

      it "renders queue_items index template" do
        post :create, video_id: video.id
        expect(response).to render_template :index
      end

      it "retrieves @queue_item array for all items including newly created" do
        Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        post :create, video_id: video.id
        expect(assigns(:queue_items).size).to eq(3)
      end

      it "retrieves @queue_item array for all items with newly created ordered last" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        post :create, video_id: video.id
        expect(assigns(:queue_items)).to eq([queue_item_1, queue_item_2, QueueItem.find_by(user: current_user, video: video)])
      end
    end

    context "with unauthenticated user" do

      it "redirects to front path" do
        post :create, video_id: video.id
        expect(response).to redirect_to front_path
      end
    end
  end


  describe "POST destroy" do
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
       
      end

      it "deletes last @queue_item" do
        queue_item = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        delete :destroy, id: queue_item.id
        expect(assigns(:queue_items)).to be_empty
      end

      it "deletes specific @queue_item" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        delete :destroy, id: queue_item_3.id
        expect(assigns(:queue_items)).to match_array([queue_item_1,queue_item_2])
      end


      it "does not delete @queue_item for different user" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: Fabricate(:user, email_address: 'xxx@xx.com'))
        delete :destroy, id: queue_item_3.id
        expect(assigns(:queue_items)).to match_array([queue_item_1,queue_item_2])
        expect(QueueItem.find(queue_item_3.id)).to eq(queue_item_3)
      end

      it "renders queue_items index template" do
        queue_item = Fabricate(:queue_item, video: Fabricate(:video), user: current_user)
        delete :destroy, id: queue_item.id
        expect(response).to render_template :index
      end

    end

    context "with unauthenticated user" do

      it "redirects to front path" do
        queue_item = Fabricate(:queue_item, video: Fabricate(:video), user: Fabricate(:user))
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to front_path
      end
    end
  end
  
end