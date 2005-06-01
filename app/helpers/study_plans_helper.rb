module StudyPlansHelper
  # prints approve links
  def approve_links
    if @session['user'].person == @study_plan.index.tutor &&
      !@study_plan.approvement
      link_to(_("approve"), :action => 'approve', :id => @study_plan)
    elsif @session['user'].person.is_a?(Leader) &&
      @session['user'].person == @study_plan.index.leader &&
      @study_plan.approvement && !@study_plan.approvement.leader_statement
      link_to(_("approve"), :action => 'approve', :id => @study_plan)
    elsif @session['user'].person.is_a?(Dean) &&
      @study_plan.approvement && @study_plan.approvement.leader_statement && 
      !@study_plan.approvement.dean_statement
      link_to(_("approve"), :action => 'approve', :id => @study_plan)
    end
  end
  # prints tutor statement
  def print_statement(message, statement)
    result = message + ': ' 
    result << approve_word(statement.result)
    unless statement.note.empty?
      result << ', ' + (_("with note: ") + statement.note)
    end
    return result
  end
  # returns approve word for statement result
  def approve_word(result)
    [ _("cancel"), _("approve")][result]
  end
end
