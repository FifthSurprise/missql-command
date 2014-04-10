class User < ActiveRecord::Base
  # attr_accessible :email, :password, :password_confirmation
  has_secure_password
  validates_presence_of :password, :on => :create
  has_many :user_levels
  has_many :levels, :through => :user_levels
  has_one :user_database, :dependent => :destroy

  after_create do 
  	self.user_database = UserDatabase.create(:name => "user_database_#{Rails.env}_#{self.id}")
  end

end
