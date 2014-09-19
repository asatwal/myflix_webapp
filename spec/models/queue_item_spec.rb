require 'spec_helper'

describe QueueItem do

  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_presence_of(:position)} 
  it {should validate_presence_of(:video)} 
   it {should validate_presence_of(:user)} 
  #it {should validate_uniqueness_of(:user)}

  let(:category) {Fabricate(:category)}  
  let(:video) {Fabricate(:video, category: category)}
  let(:user) {Fabricate(:user)}
  let(:queue_item) {Fabricate(:queue_item, user: user, video: video)}

  describe "#rating" do
    it "gets rating for queue item video review" do
      review = Fabricate(:review, user: user, reviewable: video)
      expect(queue_item.rating).to eq(review.rating)
    end

    it "gets nil rating for queue item video with no review" do
      expect(queue_item.rating).to be_nil
    end
  end

  describe "#video_title" do
    it "gets video title of assocated video" do
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#video_category" do
    it "gets video category of assocated video" do
      expect(queue_item.video_category).to eq(video.category.name)
    end
  end

  describe "#category" do
    it "gets category object of assocated video" do
      expect(queue_item.category).to eq(video.category )
    end
  end

end