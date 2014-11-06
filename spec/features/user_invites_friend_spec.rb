require 'spec_helper'

feature 'User invites friend' do 

  scenario 'user sucessfully invites friend to join myflix and invitation accepted' do
    bob = sign_in
    friend = user_invites_friend
    sign_out

    open_email friend[:email_address]
    current_email.click_link('Click here to accept invitation')

    fill_in 'Password', with: 'newpassword'
    fill_in 'Confirm Password', with: 'newpassword'
    fill_in 'Full name', with: friend[:full_name]
    click_button 'Sign Up'
    expect(page).to have_content(friend[:full_name])

    click_link "People"
    expect(page).to have_content(bob.full_name)
    sign_out

    sign_in bob
    click_link "People"
    expect(page).to have_content(friend[:full_name])

    clear_email
  end

  def user_invites_friend
    friend = Fabricate.attributes_for(:user, email_address: 'friend@friend.com') 
    visit new_invitation_path
    fill_in "Friend's Name", with: friend[:full_name]
    fill_in "Friend's Email Address", with: friend[:email_address]
    fill_in "Invitation Message", with: 'Join myflix'
    click_button 'Send Invitation'
    return friend
  end

end