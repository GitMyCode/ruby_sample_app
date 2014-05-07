class User < ActiveRecord::Base

  validates_confirmation_of :password
  #attr_accessible :name, :email, :password, :password_confirmation

  before_save { self.email = email.downcase}

  validates( :name, presence: true ,length: {maximum: 50})


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates( :email, presence: true, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false})

  # permet l'ajout des password_confirmation
  has_secure_password

  validates( :password, length: {minimum: 6})
end
