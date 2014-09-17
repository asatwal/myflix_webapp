require 'spec_helper'

describe Category do 

  #it "saves itself" do
  #  category = Category.new(name: 'Comedy')
  #  category.save
  #  expect(Category.first).to eq(category) 
  #end

  #it "has many videos" do
  #  comedy = Category.create(name: 'Comedy')
  #  south_park = Video.create(title: 'South Park', description: 'Mad Comedy', category: comedy)

  #  futurama = Video.create(title: 'Futurama', description: 'About Space', category: comedy)

  #  expect(comedy.videos).to eq([futurama, south_park]) 
  #end
  
  it {should have_many(:videos)}

  describe "#recent_videos" do

    it "returns recent videos with most recent first" do

      comedy = Category.new(name: 'Comedy')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!', created_at: 1.day.ago, category: comedy)
      futurama = Video.create(title: 'Futurama', description: 'Space adventure', category: comedy)

      expect(comedy.recent_videos()).to eq([futurama, back_to_future])
    end

    it "returns recent videos with most recent first at most 6 records" do
      comedy = Category.new(name: 'Comedy')
      back_to_future = Video.create(title: 'Back to the Future', description: 'Time travel!', created_at: 6.day.ago, category: comedy)
      back_to_future_2 = Video.create(title: 'Back to the Future 2', description: 'Time travel!', created_at: 5.days.ago, category: comedy)
      back_to_future_4 = Video.create(title: 'Back to the Future 4', description: 'Time travel!', created_at: 3.days.ago, category: comedy)
      back_to_future_5 = Video.create(title: 'Back to the Future 5', description: 'Time travel!', created_at: 2.days.ago, category: comedy)
      back_to_future_3 = Video.create(title: 'Back to the Future 3', description: 'Time travel!', created_at: 4.days.ago, category: comedy)
      back_to_future_6 = Video.create(title: 'Back to the Future 6', description: 'Time travel!', created_at: 1.days.ago, category: comedy)

      futurama = Video.create(title: 'Futurama', description: 'Space adventure', category: comedy)

      expect(comedy.recent_videos()).to eq([futurama, back_to_future_6, back_to_future_5, back_to_future_4, back_to_future_3,
                                          back_to_future_2])
    end

    it "returns empty array if no videos found in category" do

      serious = Category.new(name: 'Serious')

      expect(serious.recent_videos()).to eq([])

    end

  end

end