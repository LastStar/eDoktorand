module StudentsHelper
  # prints action links on student
  def student_action_links(student)
    if student.index.study_plan
      content_tag('b', link_to(_("study plan"), :controller => 'study_plans',
      :action => 'show', :id => student.index.study_plan))
    end
  end
end
