module StudentsHelper
  # prints action links on student
  def student_action_links(student)
    study_plan = student.index.study_plan
    if study_plan
      content_tag('b', link_to_remote(_("study plan"), {:url => {:action =>
      'show', :controller => 'study_plans', :id => study_plan}, :update =>
      "study_plans#{study_plan.id}", :loading => visual_effect(:appear,
      'loading'), :interactive => visual_effect(:fade, "loading"),
      :complete => "showStudyPlan(#{study_plan.id})"}, 
      {:id => "link#{study_plan.id}"}))
    end
  end
end
