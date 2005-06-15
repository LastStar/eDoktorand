module StudentsHelper
  # prints action links on student
  def student_action_links(student)
    if student.index.study_plan
      content_tag('b', link_to_function(_("study plan"),
      "Element.toggle('study_plan_#{student.id}')"))
    end
  end
end
