require 'spec_helper'

feature "user signs in" do 
  scenario "with valid email and password" do
    bob = sign_in
    page.should have_content bob.full_name
  end
end