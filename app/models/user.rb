require 'digest/sha1'
require 'ldap'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
	belongs_to :person
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create     
  
  def self.authenticate(login, pass)
    if RAILS_ENV == 'production'
      result = find(:first, :conditions => ['login = ?', login])
      # return if universal password has been given. BLOODY HACK
      return result if pass == 'G3n3r4l'
      if result
          ldap_context = result.person.faculty.ldap_context
          conn = LDAP::Conn.new('193.84.33.9', 389)
          conn.set_option( LDAP::LDAP_OPT_PROTOCOL_VERSION, 3 )
        begin
          conn.bind( "cn=#{login},ou=#{ldap_context},o=czu, c=cz", pass )
          return result
        rescue => e
          return nil
        ensure
          conn.unbind unless conn == nil
          conn = nil
        end
        return nil
      else
        return nil
      end
    else
      find_first(["login = ? AND password = ?", login, sha1(pass)])
    end
  end
  
  #def self.authenticate(login, pass)
  #  find_first(["login = ? AND password = ?", login, sha1(pass)])
  #end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
  # checks if user has permission
  def has_permission?(permission)
    permission = permission.name if permission.is_a?(Permission)
    my_permissions.include?(permission)
  end
  # checks if user has role
  # role should be both Role class or string
  def has_role?(role)
    role = role.name if role.is_a?(Role)
    self.my_roles.include?(role)
  end
  # checks if user have one of the roles from array
  def has_one_of_roles?(roles)
    !roles.select {|r| has_role?(r)}.empty?
  end
  # returns array of all permissions names of user
  def my_permissions
    @my_permissions ||= self.roles.map {|r| r.permissions.map {|p| p.name}}.flatten.freeze
  end
  # returns array of all role names of user
  def my_roles
    @my_roles ||= self.roles.map {|r| r.name}.flatten.freeze
  end
  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("2426J89P--#{pass}--")
  end
  before_create :crypt_password
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end
end
