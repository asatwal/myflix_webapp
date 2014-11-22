require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do 

  let(:new_user) {Fabricate.attributes_for(:user)}

  scenario 'with valid user inputs and valid card' do
    register_user(new_user, true, '4242424242424242')
    expect(page).to have_content(new_user[:full_name])
    sign_out
  end

  scenario 'with valid user inputs and invalid card' do
    register_user(new_user, true, '1234')
    expect(page).to have_content('This card number looks invalid')
  end

  scenario 'with valid user inputs and declined card' do
    register_user(new_user, true, '4000000000000002')
    expect(page).to have_content('Your card was declined')
  end

  scenario 'with invalid user inputs and valid card' do
    register_user(new_user, false, '4242424242424242')
    expect(page).to have_content('Your credit card has not been charged')
  end

  scenario 'with invalid user inputs and invalid card' do
    register_user(new_user, false, '1234')
    expect(page).to have_content('This card number looks invalid')
  end

  scenario 'with invalid user inputs and declined card' do
    register_user(new_user, false, '4000000000000002')
    expect(page).to have_content('Your credit card has not been charged')
  end
  
end

def register_user(new_user, user_valid, card_number)

  visit new_user_path

  # Miss out filling enail address to create invalid user inputs

  if user_valid
    fill_in 'Email address', with: new_user[:email_address]
  end

  fill_in 'Password', with: 'newpassword'
  fill_in 'Confirm Password', with: 'newpassword'
  fill_in 'Full name', with: new_user[:full_name]
  fill_in 'Credit Card Number', with: card_number
  fill_in 'Security Code', with: '123'
  select '11 - November', from: 'date_month'
  select '2017', from: 'date_year'
  click_button 'Sign Up'

end