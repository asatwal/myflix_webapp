require 'spec_helper'

feature "user signs in" do 

  scenario "with valid email and password" do
    bob = sign_in
    page.should have_content bob.full_name
  end

  scenario "with deactivated" do
    bill = Fabricate(:user, active: false)
    sign_in bill
    page.should_not have_content bill.full_name
    page.should have_content "Your account has been suspended. Please contact customer services."
  end

end