module Approvable
  # aproves study plan with statement from parameters 
  def approve_with(params)
    statement = \
      eval("#{params['type']}.create(params)") 
    eval("approvement.#{params['type'].underscore} =
      statement")
    if statement.is_a?(LeaderStatement) && !approvement.tutor_statement
      approvement.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    self.canceled_on = statement.cancel? ? Time.now : nil
    self.approved_on = Time.now if statement.is_a?(DeanStatement) &&
      !statement.cancel?
    save
  end
  # returns true if is approved
  def approved?
    return true unless self.approved_on.nil?
  end
end

