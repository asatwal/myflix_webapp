require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do

    it_behaves_like "with unauthenticated user" do
      let(:action) { get :new }
    end

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    context "with authenticated admin user" do

      before {set_current_admin}

      it "sets @video to a new record" do
        get :new
        expect(assigns(:video)).to be_a_new(Video)
      end
    end

  end

  describe "POST create" do

    it_behaves_like "with unauthenticated user" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end

    context "with authenticated admin user" do
      before {set_current_admin}
      let(:video_attrs) {Fabricate.attributes_for(:video)}

      context "with valid inputs" do
        it "adds a new video" do
          post :create, video: video_attrs
          expect(assigns(:video)).to eq(Video.find_by(title: video_attrs[:title]))
        end

        it "redirects to add new video page" do
          post :create, video: video_attrs
          expect(response).to redirect_to new_admin_video_path
        end

        it "sets flash success message" do
          post :create, video: video_attrs
          expect(flash[:success]).to be_present
        end

      end

      context "with invalid inputs" do
        it "does not add a new video" do
          post :create, video: {title: video_attrs[:title]}
          expect(Video.all.count).to eq(0)
        end

        it "renders the new video page" do
          post :create, video: {title: video_attrs[:title]}
          expect(response).to render_template :new
        end

        it "sets @video" do
          post :create, video: video_attrs
          expect(assigns(:video)).to be_instance_of(Video)
        end

        it "sets flash error message" do
          post :create, video: {title: video_attrs[:title]}
          expect(flash[:danger]).to be_present
        end

      end

    end
  end

end