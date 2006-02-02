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
    set_times(statement)
  end

  # returns true if is approved
  def approved?
    return true unless self.approved_on.nil?
  end

  # returns class of last approver
  def last_approver
    if approved?
      Dean
    else
      approvement.last_approver
    end
  end

  # approve like one level
  def approve_like(level, note = 'machine approve')
    person_id = self.approvement.document.index.leader.id
    statement = eval("#{level.camelize}Statement").create('person_id' => 
      self.approvement.document.index.leader.id, 'result' => 1, 'note' => note)
    self.approvement.send("#{level}_statement=", statement)
    set_times(statement)
  end

  private
  def set_times(statement)
    self.canceled_on = statement.cancel? ? Time.now : nil
    self.approved_on = Time.now if statement.is_a?(DeanStatement) &&
      !statement.cancel?
    save
  end
end

