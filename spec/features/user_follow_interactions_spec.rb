require 'spec_helper'

feature "User follow interactions " do

  scenario "user follows another user through video reviews" do

    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)

    # I seem to have to provide email and full name as Faker is not proviging random data
    bob = Fabricate(:user, email_address: 'bob@bob.com', full_name: 'Bob The Builder')
    review = Fabricate(:review, user: bob, reviewable: monk)

    sign_in

    follow_user_video_review(bob, monk)

    page.should have_content("#{bob.full_name}")

    check_follow_button_absent_for_user(bob, monk)

    unfollow_user(bob)

    # Launch in a web browser for debugging purposes
    # save_and_open_page
    page.should_not have_content("#{bob.full_name}")


  end

  def follow_user_video_review(user, video)
    visit front_path
    find("a[href='/videos/#{video.id}']").click
    # find("a[href='/users/#{user.id}']").click
    # Better to use line below for clicking on user
    click_link "#{user.full_name}"

    click_link "Follow"
  end

  def unfollow_user(user)
    visit people_path
    find("a[data-method='delete']").click
  end

  def check_follow_button_absent_for_user(user, video)
    visit front_path
    find("a[href='/videos/#{video.id}']").click
    click_link "#{user.full_name}"
    page.should_not have_content("Follow")
  end
end