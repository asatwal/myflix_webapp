require 'spec_helper'

describe User do

  it {should validate_presence_of(:email_address)}
  it {should validate_presence_of(:full_name)}
  it {should validate_uniqueness_of(:email_address)}

  it {should have_secure_password}

  it {should validate_presence_of(:password)}
  it {should ensure_length_of(:password).is_at_least(5)}
  it {should validate_confirmation_of(:password)}

  it {should have_many(:queue_items).order('position ASC')}
  it {should have_many(:reviews).order('created_at DESC')}
  it {should have_many(:following_rels)}
  it {should have_many(:leading_rels)}
  it {should have_many(:invitations).with_foreign_key(:inviter_id)}


  describe "#password_fields_blank" do
    it "confirms password fields are blank" do
      user = Fabricate.build(:user, password: '')
      expect(user.password_fields_blank?).to be true
    end
  end

  it_behaves_like "Tokenable" do
    let(:object) {Fabricate(:user)}
  end 

  it "gets queue items ordered by position" do
    current_user = Fabricate(:user)
    queue_item_1 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 3)
    queue_item_2 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 4)
    queue_item_3 = Fabricate(:queue_item, video: Fabricate(:video), user: current_user, position: 1)
    expect(current_user.queue_items).to eq([queue_item_3,queue_item_1,queue_item_2])
  end

  describe "#follows?" do
    it "returns true if given user follows the user" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      Fabricate(:relationship, leader: san, follower: hari)
      expect(hari.follows?(san)).to be true
    end

    it "returns false if given user does not follow the user" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      Fabricate(:relationship, leader: hari, follower: san)
      expect(hari.follows?(san)).to be false
    end
  end

  describe "#can_follow?" do
    it "returns true if given user is followed user already" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      Fabricate(:relationship, leader: hari, follower: san)
      expect(hari.can_follow?(san)).to be true
    end

    it "returns true if given user does not follow user already" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      expect(hari.can_follow?(san)).to be true
    end

    it "returns false if given user follows the user alreday" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      Fabricate(:relationship, leader: san, follower: hari)
      expect(hari.can_follow?(san)).to be false
    end

    it "returns false if given user is current user" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      Fabricate(:relationship, leader: hari, follower: san)
      expect(hari.can_follow?(hari)).to be false
    end
  end

  describe "#follow" do
    it "sets given user as follower" do
      san = Fabricate(:user, email_address: 'san@san.com')
      hari = Fabricate(:user, email_address: 'hari@hari.com')
      hari.follow(san)
      expect(hari.follows?(san)).to be true
    end

    it "user cannot follow oneself" do
      san = Fabricate(:user, email_address: 'san@san.com')
      san.follow(san)
      expect(san.follows?(san)).to be false
    end
  end

  describe "#deactive!" do
    it "deactives the user" do
      san = Fabricate(:user, email_address: 'san@san.com', active: true)
      san.deactivate!
      expect(san).to_not be_active
    end
  end

end