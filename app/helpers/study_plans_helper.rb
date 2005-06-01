module StudyPlansHelper
  # prints approve links
  def approve_links
    if @session['user'].person.is_a?(Tutor) &&
      !@study_plan.approvement
      link_to(_("approve"), :action => 'approve', :id => @study_plan)
    end
  end
  # prints tutor statement
  def tutor_statement(tutor_statement)
    result = ''
    result << _("Tutor statement") + ': ' 
    result << approve_word(tutor_statement.result)
    unless tutor_statement.note.empty?
      result <<_("with note: ") + tutor_statement.note
    end
    return result
  end
  # returns approve word for statement result
  def approve_word(result)
    [ _("cancel"), _("approve")][result]
  end
end
