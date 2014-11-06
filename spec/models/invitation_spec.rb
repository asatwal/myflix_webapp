require 'spec_helper'

describe Invitation do

  it {should validate_presence_of(:email_address)}
  it {should validate_presence_of(:full_name)}
  it {should validate_presence_of(:message)}
  it {should validate_uniqueness_of(:email_address)}

  it {should belong_to(:inviter).class_name(:User)}

  it_behaves_like "Tokenable" do
    let(:object) {Fabricate(:invitation)}
  end

end