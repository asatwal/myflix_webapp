require 'spec_helper'

feature 'Admin adds new video, then regular user visits video page' do 

  scenario 'admin adds video' do

    admin = sign_in_admin

    category = Fabricate(:category)
    video = Fabricate.attributes_for(:video)

    visit new_admin_video_path
    fill_in "Title", with: video[:title]
    fill_in "Description", with: video[:description]
    fill_in "Video URL", with: video[:video_url]
    select category.name, from: "Category"
    attach_file "Large cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small cover", "spec/support/uploads/monk.jpg"
    click_button "Add Video"
    sign_out

    sign_in 
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='#{video[:video_url]}']")
    sign_out

  end
end