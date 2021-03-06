require 'spec_helper'

describe Review do

  it {should belong_to(:user)}
  it {should belong_to(:reviewable)}
  it {should validate_presence_of(:comment)} 
  it {should validate_presence_of(:rating)} 

end