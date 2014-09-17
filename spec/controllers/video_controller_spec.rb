require 'spec_helper'

describe VideosController do

  describe "GET show" do

    # WITH CONTEXT FOR AUTHENICATED USER

    context "with authenticated user" do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
        @video = Fabricate(:video)
      end

      it "retrieves @video" do
        get :show, id: @video.id
        expect(assigns(:video)).to eq(@video)
      end

      it "sets @review" do
        get :show, id: @video.id
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "retrieves all the reviews created" do
        21.times do
          Fabricate(:review, user_id: session[:user_id], video_id: @video.id)
        end
        get :show, id: @video.id
        expect(assigns(:video).reviews.count).to eq(21)
      end

      it "retrieves all the reviews ordered by latest first" do
        review2 = Fabricate(:review, user_id: current_user.id, video_id: @video.id)
        review1 = Fabricate(:review, user_id: current_user.id, video_id: @video.id, created_at: 1.day.ago)

        get :show, id: @video.id
        expect(assigns(:video).reviews).to eq([review2, review1])
      end

      # No need to test - renders show template as this is Rails functionality
    end

    context "with unauthenticated user" do
      it "redirects to front_path for unauthenticated user" do
        video = Fabricate(:video)
        get :show, id: video.id
        expect(response).to redirect_to front_path
      end
    end

  end

    # WITHOUT CONTEXT FOR AUTHENICATED USER - FLATTER STRUCTURE

  describe "GET search" do
    it "retrieves @video by search term authenticated user" do
      session[:user_id] = Fabricate(:user).id

      video = Fabricate(:video, title: 'Grange Hill')
      get :search, search_term: 'Hill'
      expect(assigns(:videos)).to eq([video])
    end

    # No need to test - renders search template as this is Rails functionality

    it "redirects to front_path for unauthenticated user" do
      video = Fabricate(:video, title: 'Futurama')
      get :search, search_term: 'rama'
      expect(response).to redirect_to front_path     
    end
  end


  describe "POST review" do

    # WITH CONTEXT FOR AUTHENICATED USER

    context "with authenticated user and valid inputs" do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
        @video = Fabricate(:video)
      end

      it "retrieves @video" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(assigns(:video)).to eq(@video)
      end

      it "retrieves a Review object" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(assigns(:review)).to be_instance_of(Review)
      end

      it "sets @review to new record" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(assigns(:review).new_record?).to be true
      end

      it "@review has no errors" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(assigns(:review).errors.size).to be 0
      end

      it "saves review" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(Review.all.size).to eq(1)
      end

      it "saves review associated to video" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(Review.all.first).to eq(@video.reviews.first)
      end

      it "saves review for current user" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(Review.first.user_id).to eq(current_user.id)
      end

      it "renders template show" do
        post :review, id: @video.id, review: Fabricate.attributes_for(:review)
        expect(response).to render_template :show
      end
    end


    context "with authenticated user and invalid inputs" do
      let(:current_user) {Fabricate(:user)}
      before do
        session[:user_id] = current_user.id
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


    context "with unauthenticated user" do
      it "redirects to front_path for unauthenticated user" do
        video = Fabricate(:video)
        post :review, id: video.id, review: Fabricate.attributes_for(:review)

        expect(response).to redirect_to front_path
      end
    end

  end

end