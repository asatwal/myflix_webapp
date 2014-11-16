shared_examples "with unauthenticated user" do 
  it "redirects to front page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to front_path
  end
end

shared_examples "requires admin" do 

  before {set_current_user}

  it "redirects to root page for regular user" do
    action
    expect(response).to redirect_to root_path
  end

  it "sets flash error message for regular user" do
    action
    expect(flash[:danger]).to be_present 
  end

end

shared_examples "Tokenable" do 
  it "generates a token" do
    expect(object.token).not_to be_empty
  end
end