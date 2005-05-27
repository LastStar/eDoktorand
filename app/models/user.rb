require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
	belongs_to :person

  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
  # checks if user has permission
  def has_permission?(permission)
    my_permissions.include?(permission)
  end
    
  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("2426J89P--#{pass}--")
  end
    
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end
  # returns array of all permissions of user
  def my_permissions
    @my_permissions ||= self.roles.map {|r| r.permissions.map {|p| p.name}}.flatten.freeze
    return @my_permissions
  end

  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create     
end
