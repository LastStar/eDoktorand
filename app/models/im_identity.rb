class ImIdentity < ActiveRecord::Base

  named_scope :to_process, :conditions => {:status => 'N'}

  # returns its student by uic
  def student
    @student ||= Student.find_by_uic(uic)
  end

  # updates its student user
  def update_user
    @user = @user || student.user || student.build_user
    @user.update_attribute(:login, loginname)
    @user.roles << Role.find_by_name('student')
    self.update_attribute(:status, 'S')
  end

  class << self
    # processes all unprocessed
    def process_unprocessed
      to_process.each {|identity| identity.update_user}
    end
  end
end
