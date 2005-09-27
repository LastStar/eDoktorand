module StudentsHelper
  # prints action links on student
  def student_action_link(index)
    links = ''
    study_plan = index.study_plan
    if study_plan
      links.concat(content_tag('b',
      link_to_remote_with_loading(index.student.display_name, 
        :url => {:action => 'show', :controller => 'study_plans', :id =>
        study_plan}, :evaluate => true), {:id => "link#{study_plan.id}"}))
    end
  end
end
