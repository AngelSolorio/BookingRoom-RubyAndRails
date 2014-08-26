require 'net/ldap'
class User < ActiveRecord::Base
  has_many :suggestions
  has_many :bookings
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :first_name,presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  validates :full_name, presence: true, length: {maximum: 100}
  validates :title, presence: true, length: {maximum: 50}
  validates :department, presence: true, length: {maximum: 50}
  validates :company, presence: true, length: {maximum: 50}
  validates :admin_type, uniqueness: { conditions: -> { where.not(admin_type: 'none') }, case_sensitive: false },
                          inclusion: { in: %w(security administrative parking none),
                            message: "%{value} is not a valid type of admin" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  TREEBASE = "dc=sellcom-solutions, dc=com,dc=mx"
  FILTER_EMAIL_KEY = "mail"
  FILTER_NAME_KEY = "cn"
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false}
  has_secure_password 
  mount_uploader :photo_file, ImageUploader
  validates :password, length: { minimum: 6}
  
  #Searches a user in ldap by a given filter, at the end it returns the user found in ldap
  def self.search_in_ldap(search,filter)
    if filter=="name"
      filter = Net::LDAP::Filter.eq(FILTER_NAME_KEY,search)
    elsif filter=="email"
      filter = Net::LDAP::Filter.eq(FILTER_EMAIL_KEY,search)
    else
    end
    # Get the user's first_name, last_name and email, and return it
    ldap_user = LDAP.search(:base => TREEBASE, :filter => filter)
  end
  
  #Compares existence of users between my db and the ldap... At the end returns an array with formatted info about the requested users
  def self.data_comparison_with_ldap(ldap_users)
    @users_found=[]
    ldap_users.each do |ldap_user|
      @user = self.find_by_email(ldap_user.mail.first)
      if @user
        @users_found << {
          id: @user.id,
          full_name: @user.full_name,
          email: @user.email,
          title: @user.title,
          department: @user.department,
          company: @user.company,
          image: @user.photo_file
        }
      else  
        @users_found << {
          id: nil,
          full_name: self.check_ldap_attribute(ldap_user,'full_name'),
          email: self.check_ldap_attribute(ldap_user,'email'),
          title: self.check_ldap_attribute(ldap_user,'title'),
          department: self.check_ldap_attribute(ldap_user,'department'),
          company: self.check_ldap_attribute(ldap_user,'company'),
          image: nil 
        }
      end
    end
    @users_found
  end
    
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  private
  #Performs validations on ldap fields
  def self.check_ldap_attribute(ldap_user,attribute)
    case 
      when attribute=='first_name'
        ldap_user.respond_to?(:cn) ? ldap_user.givenname.first.force_encoding("utf-8") : nil
      when attribute=='last_name'
        ldap_user.respond_to?(:cn) ? ldap_user.sn.first.force_encoding("utf-8") : nil
      when attribute=='full_name'
        ldap_user.respond_to?(:cn) ? ldap_user.cn.first.force_encoding("utf-8") : nil
      when attribute=='email'
        ldap_user.respond_to?(:mail) ? ldap_user.mail.first.force_encoding("utf-8") : nil
      when attribute=='title'
        ldap_user.respond_to?(:title) ? ldap_user.title.first.force_encoding("utf-8") : nil
      when attribute=='department'
        ldap_user.respond_to?(:department) ? ldap_user.department.first.force_encoding("utf-8") : nil
      when attribute=='company'
        ldap_user.respond_to?(:company) ? ldap_user.title.first.force_encoding("utf-8") : nil
      else
        "Error"
      end
  end
  
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
  
end
