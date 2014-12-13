require 'spec_helper'

feature 'Admin views payments' do


  scenario 'Admin can see the payment details' do
    # Create a payment for a user
    bob = Fabricate(:user)
    payment = Fabricate(:payment, amount: 211, user: bob)

    admin = sign_in_admin
    visit admin_payments_path

    page.should have_content(bob.email_address)
    page.should have_content('£2.11')
    page.should have_content(payment.reference_id)

    sign_out
  end

  scenario 'Regular user cannot see the payment details' do
    # Create a payment for a user
    ravi = Fabricate(:user, email_address: 'ravi@ravi.com')
    payment = Fabricate(:payment, amount: 211, user: ravi)

    sign_in(ravi)
    visit admin_payments_path

    page.should_not have_content(ravi.email_address)
    page.should_not have_content('£2.11')
    page.should_not have_content(payment.reference_id)
    page.should have_content('You are not authorised to perform that action.')

  end
  
end