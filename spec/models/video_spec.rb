require 'spec_helper'

describe Video do


  # Don't need to test rails itself
  #it "saves itself" do
  #  video = Video.new(title: 'South Park', description: 'Mad Comedy')
  #  video.save
  #  Video.first.title.should == 'South Park'
  #  Video.first.description.should == 'Mad Comedy'

    # Alternative Syntax
  # expect(Video.first).to eq(video) # Preferred by RSpec team

  #  Video.first.should == video
  #  Video.first.should eq(video)
  #end

  #it "belongs to category" do
  #  comedy = Category.create(name: 'Comedy')
  #  south_park = Video.create(title: 'South Park', description: 'Mad Comedy', category: comedy)

  #  expect(south_park.category).to eq(comedy)
  #end  
  
  #it "validates title presence" do
  #  video = Video.new(description: 'Mad Comedy')
  #  video.save

  #  expect(video.errors.any?).to eq(true)
  #  expect(Video.count).to eq(0)
  #end

  
  #it "validates description presence" do
  #  video = Video.new(title: 'South Park')
  #  video.save

  #  expect(video.errors.any?).to eq(true)
  #  expect(Video.count).to eq(0)
  #end

  it {should belong_to(:category)}
  it {should have_many(:reviews).order("created_at DESC")}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}

  describe "#search_by_title" do
    before do
      @futurama = Video.create(title: 'Futurama', description: 'Space adventure')
      @back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!')
    end

    it "returns empty array on search on no match" do
      expect(Video.search_by_title('random')).to eq([])
    end

    it "returns 1 array item on exact match" do
      expect(Video.search_by_title('Futurama')).to eq([@futurama])
    end

    it "returns 1 array item on partial match" do
      expect(Video.search_by_title('rama')).to eq([@futurama])
    end

    it "returns many array items on partial match ordered by created_at" do
      south_park  = Video.create(title: 'South Park', description: 'Funny animated!')
      south_park_2 = Video.create(title: 'South Park 2', description: 'Funny animated!', created_at: 1.day.ago)

      expect(Video.search_by_title('South')).to eq([south_park, south_park_2])
    end

    it "returns empty array on empty search string" do
      expect(Video.search_by_title('')).to eq([])
    end
  end
end

describe "#average_rating" do
  it "returns rating Nil if no reviews" do
    futurama = Video.create(title: 'Futurama', description: 'Space adventure')
    expect(futurama.average_rating).to be_nil
  end

  it "returns rating 3.0 for multiple reviews with rating 3" do
    video = Fabricate(:video)
    user = Fabricate(:user)

    20.times do
      Fabricate(:review, rating: 3, user: user, reviewable: video)
    end

    expect(video.average_rating).to eq('3.0')
  end
end


