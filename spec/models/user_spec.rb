require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when a name is too long" do
    before {@user.name = 'A' *51 }
    it {should_not be_valid}
  end

  describe "when email format is invalid" do
    it "should be invalid " do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |address|
        @user.email = address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid " do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn foo@..com]
      addresses.each do |address|
        @user.email = address
        expect(@user).to be_valid
      end
    end
  end

  describe "when address is already taken" do
    it "should not be valid" do
      address = "user@foo.com"
      user1 = User.new(name: "exemple1", email: address)
      user2 = User.new(name: "exemple2", email: address)
      user2.email = user2.email.upcase
      user1.save
      puts user2.email
      expect(user2).not_to be_valid

    end
  end


  describe "when address is not taken" do
    it "should be valid" do

    end
  end







end
