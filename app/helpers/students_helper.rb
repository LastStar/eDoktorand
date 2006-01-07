module StudentsHelper
  
  # prints action links on student
  def student_action_link(index)
    info = ''
    links = ''
    study_plan = index.study_plan
    if @user.has_one_of_roles?(['dean', 'faculty_secretary', 'vicerector'])
      info.concat(div_tag("#{index.coridor.code}", {:class => 'smallerinfo'}))
      info.concat(div_tag("#{index.department.short_name}", {:class => 'smallerinfo'})) 
      if study_plan && @user.has_one_of_roles?(['dean', 'faculty_secretary'])
        links.concat(div_tag(link_to_remote_with_loading(
          _('switch study'), :url => {:action => 'switch_study', :controller =>
          'students', :id => index}, :evaluate => true), {:id =>
          "link#{study_plan.id}", :class => 'smallinfo'})) 
        links.concat(div_tag(link_to(_('change SP'), :action => 
          'change', :controller => 'study_plans', :id =>
          index.student), {:class => 'smallinfo'}))
        if index.admited_interupt? && index.interupt.approved?
          links.concat(div_tag(link_to_remote_with_loading(
            _('interupt'), :url => {:action => 'confirm', :controller => 
            'interupts', :id => index}, :evaluate => true, :confirm => 
            _('Do you really want to interupt this study?')), {:class => 
            'smallinfo'})) 
        end
      end
      if index.student.scholarship_claim_date && !index.student.scholarship_supervised_date
        links.concat(div_tag(link_to_remote_with_loading(
        _('supervise scholarship'), :url => {:action => 'supervise_scholarship_claim', :controller =>
        'students', :id => index}, :evaluate => true), {:id =>
        "claim_link#{index.id}", :class => 'smallinfo'})) 
      end
    end
    info.concat(div_tag("#{index.study.name}", {:class => 'smallinfo'}))
    info.concat(div_tag("#{index.year}. #{_('year')}", {:class => 'smallinfo'}))
    info.concat(div_tag(index.status, {:class => 'smallinfo'}))
    if study_plan
      info.concat(div_tag(study_plan.status, {:class => 'smallinfo'}))
      links.concat(finish_link(index))
    else
      links.concat(finish_link(index))
      if @user.has_one_of_roles?(['admin', 'department_secretary', 
        'faculty_secretary', 'dean']) && !index.finished?
        links.concat(div_tag(link_to(_('create SP'), :action => 
          'create_by_other', :controller => 'study_plans', :id =>
          index.student), {:class => 'smallinfo'}))
      end
    end
    info.concat(content_tag('span', link_to_remote_with_loading(
      index.student.display_name, :url => {:action => 'show', :controller => 
      'students', :id => index}, :evaluate => true), {:id => 
      "link#{index.id}", :class => 'printable'}))
    links.concat(interupt_link(index)) unless index.finished? 
    unless links.empty?
      info = div_tag(link_to_function(_('menu'), "Element.toggle( \
        'index_menu_#{index.id}')"), :class => 'smallerinfo').concat(info)
      links.concat('&nbsp;')
    end
    div_tag(links, :id => "index_menu_#{index.id}", :style => 'display: none',
      :class => 'menu_line') + div_tag(info, :class => index.year > 3 ? 'red':\
      '') 
  end 

  # prints code to switch old student link to new one
  def redraw_student(index)
    update_element_function("index_line_#{index.id}", :content => student_action_link(index))
  end

  def print_scholarship(index)
    ScholarshipCalculator.scholarship_for(index.student)
  end

  # prints finish link
  def finish_link(index)
    if @user.has_one_of_roles?(['faculty_secretary', 'dean'])
      if index.finished? 
        div_tag(link_to_remote_with_loading(_('unfinish study'),
          :url => {:action => 'unfinish', :controller => 'students', :id => 
          index}, :evaluate => true, :confirm => 
          _('Are you sure you want to unfinish this study?')), {:class => 
          'smallinfo'})
      else 
        div_tag(link_to_remote_with_loading(_('finish study'), 
          :url => {:action => 'finish', :controller => 'students', :id =>
          index}, :evaluate => true, :confirm =>
          _('Are you sure you want to finish this study?')), 
          {:class => 'smallinfo'})
      end
    end
  end
 
  # prints interupt link
  def interupt_link(index)
    if @user.has_one_of_roles?(['faculty_secretary', 'dean'])
        div_tag(link_to(_('interupt study'), {:action => 'index', 
          :controller => 'interupts', :id => index}, :confirm => 
          _('Are you sure you want to interupt this study?')), 
          {:class => 'smallinfo'})
    end
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

  # prints select for statuses
  def study_status_select(options = {})
    content_tag('select', study_status_options, {'id' => 
      "filter_by_study_status", 'name' => "filter_by_study_status"})
  end

  # prints select for statuses
  def form_select(options = {})
    content_tag('select', form_options, {'id' => 
      "filter_by_form", 'name' => "filter_by_form"})
  end
end
