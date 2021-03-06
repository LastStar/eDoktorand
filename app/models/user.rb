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
    if RAILS_ENV == "production"
      result = find(:first, :conditions => ['login = ?', login])
      # return if universal password has been given. Set in the config/initializa f
      if Digest::SHA2.hexdigest(pass) == UNIVERSAL_PASSWORD
        logger.info "Used general passwd for %s" % login
        return result.id
      end
      # return if external tutor password fiven. BLOODY HACK
      if login =~ /^ex_/ && pass == "#{result.id}:#{login}"
        logger.info "Used external tutor passwd for %s" % login
        return result.id
      end
      if result
        # another bloody hack
        if result.has_role?('supervisor')
          ldap_context = 'pef'
        # another bloody hack
        elsif result.has_role?('university_secretary')
          ldap_context = 'rektorat'
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
