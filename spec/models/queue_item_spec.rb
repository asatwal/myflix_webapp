require 'spec_helper'

describe QueueItem do

  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_presence_of(:position)} 
  it {should validate_presence_of(:video)} 
  it {should validate_presence_of(:user)} 
#  it {should validate_uniqueness_of(:user).scoped_to(:video_id)}
  it {should validate_numericality_of(:position).only_integer} 

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

 describe "#rating=" do
    let(:review) {Fabricate(:review, user: user, reviewable: video, rating: 2)}

    it "updates an existing rating for a review" do

      expect(review.rating).to eq(2)
      queue_item.rating = 5
      expect(QueueItem.find(queue_item.id).rating).to eq(5)
    end

    it "updates an existing nil rating for a review" do
      expect(review.rating).to eq(2)
      queue_item.rating = nil
      expect(QueueItem.find(queue_item.id).rating).to be_nil
    end


    it "creates a new review with rating if no reviews" do
     queue_item.rating = 4
     expect(Review.all.count).to eq(1)
     expect(Review.first.rating).to eq(4)
   end
  end

end