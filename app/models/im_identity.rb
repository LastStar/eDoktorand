class ImIdentity < ActiveRecord::Base

  # returns its student by uic
  def student
    @student ||= Student.find_by_uic(uic)
  end

  # updates its student user
  def update_user
    @user = @user || student.user || student.build_user
    @user.update_attribute(:login, loginname)
    self.update_attribute(:status, 'S')
  end
end
