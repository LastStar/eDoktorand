module StudentsHelper
  # prints action links on student
  def student_action_link(index)
    links = ''
    study_plan = index.study_plan
    if study_plan
      links.concat(content_tag('b', link_to_remote(_("study"), {:url => {:action =>
      'show', :controller => 'study_plans', :id => study_plan}, :loading => 
      visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade, 
      "loading"), :complete => evaluate_remote_response}), 
      {:id => "link#{study_plan.id}"}))
    end
    links.concat(content_tag('b', link_to_remote(_("contact"), :url => {:action => 'contact',
    :id => index.student.id}, :loading => visual_effect(:appear, 'loading'), 
    :interactive => visual_effect(:fade, "loading"), :complete =>
    evaluate_remote_response), :id => "contact_link#{index.id}"))
  end
end
