shared_examples "with unauthenticated user" do 
  it "redirects to front page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to front_path
  end
end