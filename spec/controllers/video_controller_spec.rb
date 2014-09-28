require 'spec_helper'

describe VideosController do

  describe "GET show" do

    # WITH CONTEXT FOR AUTHENICATED USER

    context "with authenticated user" do
      let(:video) {Fabricate(:video)}
      before { set_current_user}

      it "retrieves @video" do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it "sets @review" do
        get :show, id: video.id
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "retrieves all the reviews created" do
        21.times do
          Fabricate(:review, user: current_user, reviewable: video)
        end
        get :show, id: video.id
        expect(assigns(:video).reviews.count).to eq(21)
      end

      it "retrieves all the reviews ordered by latest first" do
        review2 = Fabricate(:review, user: current_user, reviewable: video)
        review1 = Fabricate(:review, user: current_user, reviewable: video, created_at: 1.day.ago)

        get :show, id: video.id
        expect(assigns(:video).reviews).to eq([review2, review1])
      end

      # No need to test - renders show template as this is Rails functionality
    end

    it_behaves_like "with unauthenticated user" do
      let(:action) do
        video = Fabricate(:video)
        get :show, id: video.id
      end
    end 
  end

    # WITHOUT CONTEXT FOR AUTHENICATED USER - FLATTER STRUCTURE

  describe "GET search" do
    it "retrieves @video by search term authenticated user" do
      set_current_user

      video = Fabricate(:video, title: 'Grange Hill')
      get :search, search_term: 'Hill'
      expect(assigns(:videos)).to eq([video])
    end

    # No need to test - renders search template as this is Rails functionality

    it_behaves_like "with unauthenticated user" do
      let(:action) do
        video = Fabricate(:video, title: 'Futurama')
        get :search, search_term: 'rama'
      end
    end 
  end


  describe "POST review" do

    # WITH CONTEXT FOR AUTHENICATED USER

    context "with authenticated user and valid inputs" do
      let(:video) {Fabricate(:video)}
      let(:review_attrs) {Fabricate.attributes_for(:review, user: current_user, reviewable: video)}
      before { set_current_user}

      it "retrieves @video" do
        post :review, id: video.id, review: review_attrs
        expect(assigns(:video)).to eq(video)
      end

      it "retrieves a Review object" do
        post :review, id: video.id, review: review_attrs
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "sets @review to new record" do
        post :review, id: video.id, review: review_attrs
        expect(assigns(:review).new_record?).to be true
      end

      it "@review has no errors" do
        post :review, id: video.id, review: review_attrs
        expect(assigns(:review).errors.size).to be 0
      end

      it "saves review" do
        post :review, id: video.id, review: review_attrs
        expect(Review.all.size).to eq(1)
      end

      it "saves review associated to video" do
        post :review, id: video.id, review: review_attrs
        expect(Review.all.first).to eq(video.reviews.first)
      end

      it "saves review for current user" do
        post :review, id: video.id, review: review_attrs
        expect(Review.first.user_id).to eq(current_user.id)
      end

      it "renders template show" do
        post :review, id: video.id, review: review_attrs
        expect(response).to render_template :show
      end
    end


    context "with authenticated user and invalid inputs" do
      before do
        set_current_user
        @video = Fabricate(:video)
      end

      it "retrieves @video" do
        post :review, id: @video.id, review: {rating: Faker::Number.number(1)}
        expect(assigns(:video)).to eq(@video)
      end

      it "retrieves a Review object" do
        post :review, id: @video.id, review: {rating: Faker::Number.number(1)}
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "sets @review to new record" do
        post :review, id: @video.id, review: {rating: Faker::Number.number(1)}
        expect(assigns(:review)).to be_instance_of(Review)
        expect(assigns(:review).new_record?).to be true
      end

      it "@review has errors" do
        post :review, id: @video.id, review: {rating: Faker::Number.number(1)}
        expect(assigns(:review).errors.size).to be > 0
      end

      it "does not save review" do
        post :review, id: @video.id, review: {rating: Faker::Number.number(1)}
        expect(Review.all.size).to eq(0)
      end

      it "renders template show" do
        post :review, id: @video.id, review: {rating: Faker::Number.number(1)}
        expect(response).to render_template :show
      end
    end

    it_behaves_like "with unauthenticated user" do
      let(:action) do
        user = Fabricate(:user)
        video = Fabricate(:video)
        review_attrs = Fabricate.attributes_for(:review, user: user, reviewable: video)
        post :review, id: video.id, review: review_attrs
      end
    end
  end
end

