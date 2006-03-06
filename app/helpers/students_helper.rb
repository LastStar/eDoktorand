module StudentsHelper
  
  # prints action links on student
  def student_action_link(index)
    info = ''
    links = ''
    forms = ''
    study_plan = index.study_plan 
    if @user.has_one_of_roles?(['dean', 'faculty_secretary', 'vicerector'])
      info.concat(smaller_info_div("#{index.coridor.code}"))
      info.concat(smaller_info_div("#{index.department.short_name}")) 
      links.concat(switch_link(index)) 
      links.concat(finish_link(index)) 
      if index.waits_for_scholarship_confirmation?
        links.concat(supervise_scholarship_link(index)) 
      end
      if study_plan
        links.concat(change_link(index))
      else
        links.concat(create_link(index))
      end
      if index.not_even_admited_interupt?
        links.concat(interupt_link(index))
      end
      if index.interupt_waits_for_confirmation?
        links.concat(confirm_interupt_link(index)) 
      end
      if index.close_to_interupt_end_or_after?
        links.concat(end_interupt_link(index))
        status_class = 'ends_interupt'
      end
    end
    info.concat(div_tag("#{index.study.name}", {:class => 'smallinfo'}))
    info.concat(div_tag("#{index.year}. #{_('year')}", {:class => 'smallinfo'}))
    info.concat(div_tag(index.status, {:class => ['smallinfo',
      status_class].join(' ')}))
    if study_plan
      info.concat(div_tag(study_plan.status, {:class => 'smallinfo'}))
    end
    info.concat(content_tag('span', student_link(index), {:id => 
      "link#{index.id}", :class => 'printable'}))
    unless links.empty?
      info = smaller_info_div(menu_link(index)).concat(info)
      links.concat('&nbsp;')
    end
    div_tag(links, :id => "index_menu_#{index.id}", :style => 'display: none',
      :class => 'menu_line') + div_tag(info, :class => index.line_class) +
      div_tag('', :id => "index_form_#{index.id}", :style => 'display: none',
      :class => 'menu_line')
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
    if index.finished? 
      small_info_div(link_to_remote_with_loading(_('unfinish study'),
        :url => {:action => 'unfinish', :controller => 'students', 
        :id => index}, :update => "index_form_#{index.id}"))
    else 
      small_info_div(link_to_remote_with_loading(_('finish study'), 
        :url => {:action => 'time_form', :controller => 'students', 
        :form_action => 'finish', :id => index}, :update =>
        "index_form_#{index.id}"))
    end
  end
 
  # prints link to switch study form
  def switch_link(index)
    small_info_div(link_to_remote_with_loading( _('switch study'), :url => 
      {:action => 'time_form', :controller => 'students', :form_action => 
      'switch_study', :id => index}, :update => "index_form_#{index.id}"))
  end

  # prints interupt link
  def interupt_link(index)
    small_info_div(link_to(_('interrupt study'), {:action => 'index', 
      :controller => 'interupts', :id => index}))
  end

  # prints confirm interupt link
  def confirm_interupt_link(index)
    small_info_div(link_to_remote_with_loading(_('confirm interrupt'), :url =>
      {:action => 'time_form', :controller => 'students', :form_action => 
      'confirm', :form_controller => 'interupts', :id => index, :date =>
      index.interupt.start_on}, :update => "index_form_#{index.id}"))
  end

  # prints end interupt link
  def end_interupt_link(index)
    small_info_div(link_to_remote_with_loading(_('end interrupt'), :url =>
      {:action => 'time_form', :controller => 'students', :form_action => 
      'end', :form_controller => 'interupts', :id => index, :date =>
      index.interupt.end_on}, :update => "index_form_#{index.id}"))
  end

  # prints link to change study plan
  def change_link(index)
    div_tag(link_to(_('change SP'), {:action => 'change', :controller => 
      'study_plans', :id => index.student}, {:class => 'smallinfo'}))
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

  # prints link to supervise scholarship
  def supervise_scholarship_link(index)
    div_tag(link_to_remote_with_loading(
      _('supervise scholarship'), :url => {:controller => 'students', 
      :action => 'supervise_scholarship_claim',  :id => index}, :evaluate =>
      true), {:id => "claim_link#{index.id}", :class => 'smallinfo'})
  end

  # prints menu link
  def menu_link(index)
    link_to_function(_('menu'), "Element.toggle('index_menu_#{index.id}', 'index_form_#{index.id}')")
  end

  # prints month year form
  def month_year_form(options)
    date = options[:date] ? Time.parse(options.delete(:date)) : Date.today
    result = form_remote_with_loading(options)
    result << select_month(date)
    result << select_year(date, :start_year => 2000)
    result << submit_tag(_(options[:url][:action].humanize))
    result << end_form_tag
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

  # prints interupt finish line
  def interupt_finish_line(index)
    if index.interupt.finished_on
      finished_on = index.interupt.finished_on.strftime('%d.%m.%Y')
      finished_on = info_div(finished_on)
      content_tag('li', finished_on + _('finished on'))
    end
  end

end
