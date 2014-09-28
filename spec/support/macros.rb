def set_current_user(existing_user = nil)
  user = existing_user || Fabricate(:user)
  session[:user_id] = user.id
  user
end

def current_user
  User.find(session[:user_id]) if session[:user_id]
end

def sign_in(existing_user = nil)
    user = existing_user || Fabricate(:user)
    visit sign_in_path
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: user.password
    click_button "Sign in"
    user
end