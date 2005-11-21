module StudentsHelper
  # prints action links on student
  def student_action_link(index)
    info = ''
    links = ''
    study_plan = index.study_plan
    if @user.has_one_of_roles?(['dean', 'faculty_secretary', 'vicerector'])
      info.concat(div_tag("#{index.coridor.code}", {:class => 'smallerinfo'}))
      info.concat(div_tag("#{index.department.short_name}", {:class => 'smallerinfo'})) 
      if study_plan
        links.concat(div_tag(link_to_remote_with_loading(
          _('switch study'), :url => {:action => 'show', :controller =>
          'study_plans', :id => study_plan}, :evaluate => true), {:id =>
          "link#{study_plan.id}", :class => 'smallinfo'})) 
      end
    end
    info.concat(div_tag("#{index.study.name}", {:class => 'smallinfo'}))
    info.concat(div_tag("#{index.year}. #{_('year')}", {:class => 'smallinfo'}))
    info.concat(div_tag(index.status, {:class => 'smallinfo'}))
    if study_plan
      info.concat(div_tag(study_plan.status, {:class => 'smallinfo'}))
      links.concat(finish_link(index))
      info.concat(content_tag('b',
      link_to_remote_with_loading(index.student.display_name, 
        :url => {:action => 'show', :controller => 'study_plans', :id =>
        study_plan}, :evaluate => true), {:id => "link#{study_plan.id}", 
        :class => 'printable'}))
    else
      links.concat(finish_link(index))
      if @user.has_one_of_roles?(['admin', 'department_secretary', 'faculty_secretary', 'dean']) && !index.finished?
        links.concat(div_tag(link_to(_('create SP'), :action => 
          'create_by_other', :controller => 'study_plans', :id =>
          index.student), {:class => 'smallinfo'}))
      end
      info.concat(content_tag('b',index.student.display_name))
    end
    unless links.empty?
      info = div_tag(link_to_function(_('menu'), "Element.toggle( \
        'index_menu_#{index.id}')"), :class => 'smallinfo').concat(info)
      links.concat('&nbsp;')
    end
    div_tag(links, :id => "index_menu_#{index.id}", :style => 'display: none') + div_tag(info)
  end 
# prints code to switch old student link to new one
  def switch_student(student)
    update_element_function("index_line_#{student.index.id}", :content => student_action_link(student.index))
  end
  def print_scholarship(index)
    ScholarshipCalculator.scholarship_for(index.student)
  end
  def finish_link(index)
    result = ''
    if index.finished? 
      if @user.has_one_of_roles?(['faculty_secretary', 'dean'])
        result.concat(div_tag(link_to_remote_with_loading(_('unfinish study'),
          :url => {:action => 'unfinish', :controller => 'students', :id => 
          index.student}, :evaluate => true, :confirm => 
          _('Are you sure you want to unfinish this study?')), {:class => 
          'smallinfo'}))
      end
    else 
      if @user.has_one_of_roles?(['faculty_secretary', 'dean'])
        result.concat(div_tag(link_to_remote_with_loading(_('finish study'), 
          :url => {:action => 'finish', :controller => 'students', :id =>
          index.student}, :evaluate => true, :confirm =>
          _('Are you sure you want to finish this study?')), 
          {:class => 'smallinfo'}))
      end
    end
    return result
  end
# prints select for departments
  def department_select(options = {})
    options = if options[:user].has_role?('vicerector')
      department_options(:include_empty => options[:include_empty])
    else
      department_options(:faculty => options[:user].person.faculty, :include_empty => options[:include_empty])
    end
    content_tag('select', options, {'id' => "filter_by_department", 
      'name' => "filter_by_department"})
  end
# prints select for coridor
  def coridor_select(options = {})
    options = if options[:user].has_role?('vicerector')
      coridor_options(:include_empty => options[:include_empty])
    else
      coridor_options(:faculty => options[:user].person.faculty, :include_empty => options[:include_empty])
    end
    content_tag('select', options, {'id' => "filter_by_coridor", 
      'name' => "filter_by_coridor"})
  end
# prints select for faculty
  def faculty_select(options = {})
    content_tag('select', faculty_options(:include_empty => true), {'id' => 
      "filter_by_faculty", 'name' => "filter_by_faculty"})
  end
# prints select for statuses
  def status_select(options = {})
    content_tag('select', status_options, {'id' => 
      "filter_by_status", 'name' => "filter_by_status"})
  end
end
