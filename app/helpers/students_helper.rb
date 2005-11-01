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
    else
      links.concat(content_tag('b',index.student.display_name))
    end
    if @session['user'].has_one_of_roles?(['dean', 'faculty_secretary', 'vicerector'])
      links.concat(content_tag('div', "#{index.coridor.code}", {:class => 'smallinfo'}))
      links.concat(content_tag('div', "#{index.department.short_name}", {:class => 'smallinfo'})) 
    end
    links.concat(content_tag('div', "#{index.year}. #{_('year')}", {:class => 'smallinfo'}))
  end
end
