module StudentsHelper
  
  # prints action links on student
  def student_action_link(index)
    info = ''
    links = ''
    study_plan = index.study_plan
    if @user.has_one_of_roles?(['dean', 'faculty_secretary', 'vicerector'])
      info.concat(smaller_info_div("#{index.coridor.code}"))
      info.concat(smaller_info_div("#{index.department.short_name}")) 
      if !index.interupted? && !index.admited_interupt?
        links.concat(interupt_link(index))
      end
      if index.admited_interupt? && index.interupt.approved?
        links.concat(confirm_interupt_link(index)) 
      end
      if study_plan && @user.has_one_of_roles?(['dean', 'faculty_secretary'])
        links.concat(switch_link(index)) 
        links.concat(change_link(index))
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
    links.concat(finish_link(index))
    if study_plan
      info.concat(div_tag(study_plan.status, {:class => 'smallinfo'}))
    else
      links.concat(create_link(index))
    end
    info.concat(content_tag('span', student_link(index), {:id => 
      "link#{index.id}", :class => 'printable'}))
    unless links.empty?
      info = smaller_info_div(link_to_function(_('menu'), "Element.toggle( \
        'index_menu_#{index.id}')")).concat(info)
      links.concat('&nbsp;')
    end
    div_tag(links, :id => "index_menu_#{index.id}", :style => 'display: none',
      :class => 'menu_line') + div_tag(info, :class => index.line_class) 
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
    else
      ''
    end
  end
 
  # prints interupt link
  def interupt_link(index)
      div_tag(link_to(_('interrupt study'), {:action => 'index', 
        :controller => 'interupts', :id => index}), {:class => 'smallinfo'})
  end

  # prints interupt link
  def confirm_interupt_link(index)
      div_tag(link_to(_('confirm interrupt'), {:action => 'confirm', 
        :controller => 'interupts', :id => index}, :confirm => 
        _('Are you sure you want to interupt this study?')), 
        {:class => 'smallinfo'})
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

  # returns link for fast filter
  def fast_filter_link
    link_to_function(_('Fast filter'), "Element.toggle('fast_info',\
      'fast_search')", :class => 'legend_link') 
  end

  # returns link for details fiter 
  def detail_filter_link
    link_to_function(_('Detail filter'), "Element.toggle('detail_info',\
      'detail_search')", :class => 'legend_link') 
  end

  # prints div with smallerinfo class with content inside
  def smaller_info_div(content)
    div_tag(content, {:class => 'smallerinfo'})
  end

  # prints link to create new study plan
  def create_link(index)
    if @user.has_one_of_roles?(['admin', 'department_secretary', 
      'faculty_secretary', 'dean']) && !index.finished?
      div_tag(link_to(_('create SP'), :action => 
        'create_by_other', :controller => 'study_plans', :id =>
        index.student), {:class => 'smallinfo'})
    else
      ''
    end
  end

  # prints link to switch study form
  def switch_link(index)
    div_tag(link_to_remote_with_loading( _('switch study'), :url => {:action =>
      'switch_study', :controller => 'students', :id => index}, :evaluate =>
      true),  {:id => "link#{index.study_plan.id}", :class => 'smallinfo'})
  end

  # prints link to change study plan
  def change_link(index)
    div_tag(link_to(_('change SP'), {:action => 'change', :controller => 
      'study_plans', :id => index.student}, {:class => 'smallinfo'}))
  end

  # prints lint to interupt study
  def confirm_interupt_link(index)
    link_to_remote_with_loading( _('confirm interupt'), {:url => {:action => 'confirm',
      :controller => 'interupts', :id => index}, :evaluate => true}, {:class =>
      'smallinfo'})
  end

  def student_link(index)
    link_to_remote_with_loading(index.student.display_name, :url => {:action =>
      'show', :controller => 'students', :id => index}, :evaluate => true)
  end

  # returns search info line
  def search_info(filters, filter)
    content =  _('For opening filter options click the legend. Currently selected fiter is:')
    content << ' ' << filters.detect {|f| f.last == filter.to_i}.first
    div_tag(content, :id => 'fast_info', :class => 'form_info')
  end
end
