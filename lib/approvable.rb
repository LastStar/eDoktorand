module Approvable
  # approves study plan with statement from parameters
  def approve_with(params)
    statement = eval("#{params['type']}.create(params)")
    eval("self.approval.#{params['type'].underscore} = statement")
    if statement.is_a?(LeaderStatement) && !self.approval.tutor_statement
      self.approval.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    self.approval.save
    set_times(statement)
  end

  # returns true if is approved
  def approved?
    !self.approved_on.nil?
  end

  # returns class of last approver
  def last_approver
    if approved?
      Dean
    else
      approval.last_approver
    end
  end

  # approve like one level
  def approve_like(level, note = 'machine approve')
    unless self.approval
      if self.is_a? StudyInterrupt
        type = 'Interrupt'
      else
        type = self.class.to_s
      end
      self.approval = eval("#{type}Approval.new")
    end
    person_id = self.approval.document.index.send(level).id
    statement = eval("#{level.camelize}Statement").create('person_id' =>
      person_id, 'result' => 1, 'note' => note)
    self.approval.update_attribute("#{level}_statement_id", statement.id)
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

