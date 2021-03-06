require 'spec_helper'

describe User do

  describe "test creation avec Factory" do
    before do
      @user = FactoryGirl.create(:user)
    end

    it {should be_valid}

  end



  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar" )
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin)}

  it { should be_valid }
  it { should_not be_admin }

  describe "un user avec admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it {should be_admin}
  end


  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end



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


  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end





end
