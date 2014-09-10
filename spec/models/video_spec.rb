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
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}  

  describe "#search_by_title" do

    it "returns empty array on search on no match" do
      futurama = Video.create(title: 'Futurama', description: 'Space adventure')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!')

      expect(Video.search_by_title('random')).to eq([])
    end

    it "returns 1 array item on exact match" do
      futurama = Video.create(title: 'Futurama', description: 'Space adventure')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!')

      expect(Video.search_by_title('Futurama')).to eq([futurama])
    end

    it "returns 1 array item on partial match" do
      futurama = Video.create(title: 'Futurama', description: 'Space adventure')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!')

      expect(Video.search_by_title('rama')).to eq([futurama])
    end


    it "returns many array items on partial match ordered by created_at" do
      futurama = Video.create(title: 'Futurama', description: 'Space adventure')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!', created_at: 1.day.ago)

      expect(Video.search_by_title('Futur')).to eq([futurama, back_to_future])
    end

    it "returns empty array on empty search string" do
      futurama = Video.create(title: 'Futurama', description: 'Space adventure')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!')

      expect(Video.search_by_title('')).to eq([])
    end

  end

end
