require 'spec_helper'

describe User do

  it {should validate_presence_of(:email_address)}
  it {should validate_presence_of(:full_name)}
  it {should validate_uniqueness_of(:email_address)}

  it {should have_secure_password}

  it {should validate_presence_of(:password)}
  it {should ensure_length_of(:password).is_at_least(5)}
  it {should validate_confirmation_of(:password)}

  it {should have_many(:queue_items)}

  describe "#password_fields_blank" do
    it "confirms password fields are blank" do
      user = Fabricate.build(:user, password: '')
      expect(user.password_fields_blank?).to be true
    end
  end

  it "gets queue items ordered by position" do
    current_user = Fabricate(:user)
    queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
    queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 4)
    queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
    expect(current_user.queue_items).to eq([queue_item_3,queue_item_1,queue_item_2])
  end
end