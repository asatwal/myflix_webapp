require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do

    context "with authenticated user" do
      before { set_current_user}

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

    it_behaves_like "with unauthenticated user" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
      let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      before { set_current_user}

      it "sets the danger notice on invalid input" do
        post :create
        expect(flash[:danger]).to be_present
      end

      it "retrieves single @queue_item newly created" do
        post :create, video_id: video.id
        expect(assigns(:queue_items).size).to eq(1)
      end

      it "does not allow @queue_item to be created with identical video" do
        post :create, video_id: video.id
        post :create, video_id: video.id
        expect(assigns(:queue_items).size).to eq(1)
        expect(flash[:danger]).to be_present
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

    it_behaves_like "with unauthenticated user" do
      let(:action) {post :create, video_id: video.id}
    end 
  end

  describe "POST update_queue" do
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      before { set_current_user}

      it "renders queue_items index template" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 4)
         post :update_queue, queue_items: [{ id: queue_item_1.id, position: 1}, { id: queue_item_2.id, position: 2}]
        expect(response).to render_template :index
      end


      it "renders queue_items index template on invalid input" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 1.5}, { id: queue_item_2.id, position: 2}]
        expect(response).to render_template :index
      end

      it "sets the danger notice on invalid input" do
       queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 1.5}, { id: queue_item_2.id, position: 3}]
        expect(flash[:danger]).to be_present
      end

      it "does not save queue_items order on invalid input" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 10.5}, { id: queue_item_2.id, position: 3}, { id: queue_item_3.id, position: 1}]
        expect(assigns(:queue_items)).to eq([queue_item_1, queue_item_2,queue_item_3])
      end

      it "updates @queue_item array order by new positions" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        queue_item_4 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 4)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 2}, { id: queue_item_2.id, position: 1}, { id: queue_item_3.id, position: 4}, { id: queue_item_4.id, position: 3}]
        expect(assigns(:queue_items)).to eq([queue_item_2, queue_item_1,queue_item_4,queue_item_3])
      end

      it "updates @queue_item array order by new positions with queue numbers starting at 1" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 10)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 20)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 30)
        queue_item_4 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 40)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 7}, { id: queue_item_2.id, position: 6}, { id: queue_item_3.id, position: 9}, { id: queue_item_4.id, position: 8}]
        expect(assigns(:queue_items).map(&:position)).to eq([1,2,3,4])
      end

      it "one of the queue items being updated is not associated to current user" do
        bob = Fabricate(:user, email_address: 'bob.singh@singh.com')
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: bob, position: 2)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        queue_item_4 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 4)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 2}, { id: queue_item_2.id, position: 1}, { id: queue_item_3.id, position: 4}, { id: queue_item_4.id, position: 3}]
        expect(assigns(:queue_items)).to eq([queue_item_1,queue_item_4,queue_item_3])
      end

      it "updates @queue_item new positions with ratings" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 5)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 7, rating: 3}, { id: queue_item_2.id, position: 6, rating: 4}, { id: queue_item_3.id, position: 9, rating: 5}]
        expect(assigns(:queue_items).map(&:rating)).to eq([4,3,5])
      end

      it "updates @queue_item new positions with ratings and nil ratings" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        post :update_queue, queue_items: [{ id: queue_item_1.id, position: 1, rating: 3}, { id: queue_item_2.id, position: 2}, { id: queue_item_3.id, position: 3, rating: 5}]
        expect(assigns(:queue_items).map(&:rating)).to eq([3,nil,5])
      end


    end

    it_behaves_like "with unauthenticated user" do
      let(:action) {post :update_queue, video_id: video.id}
    end 

  end

  describe "POST destroy" do
    let(:video) { Fabricate(:video) }

    context "with authenticated user" do
      before { set_current_user}

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

    it "updates @queue_item array order by new positions with queue numbers starting at 1" do
        queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
        queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 2)
        queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
        queue_item_4 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 7)
        delete :destroy, id: queue_item_1.id        
        expect(assigns(:queue_items).map(&:position)).to eq([1,2,3])
      end
    end


    it_behaves_like "with unauthenticated user" do
      let(:action) do
        queue_item = Fabricate(:queue_item, video: Fabricate(:video), user: Fabricate(:user))
        delete :destroy, id: queue_item.id
      end
    end 
  end
  
end