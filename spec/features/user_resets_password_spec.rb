require 'spec_helper'

feature 'User resets password' do 
  scenario 'user sucessfully resets password' do
    bill = Fabricate(:user)
    visit sign_in_path
    click_link 'Forgot password'

    fill_in 'Email address', with: bill.email_address
    click_button 'Send Email'

    open_email(bill.email_address)
    current_email.click_link('Click here to reset password')

    fill_in 'password', with: 'newpassword'
    fill_in 'password_confirmation', with: 'newpassword'
    click_button 'Reset Password'

    fill_in 'Email address', with: bill.email_address
    fill_in 'Password', with: 'newpassword'
    click_button 'Sign in'
    expect(page).to have_content("#{bill.full_name}")

    clear_email
  end
end