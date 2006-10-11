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
      unless index.status == _('absolved')
        links.concat(switch_link(index)) 
        links.concat(finish_link(index)) 
        if index.waits_for_scholarship_confirmation?
          links.concat(supervise_scholarship_link(index)) 
        end
        if study_plan
          if study_plan.all_subjects_finished?
            if index.final_exam_passed?
              links.concat(pass_link(:defense, index))
            else
              links.concat(pass_link(:final_exam, index))
            end
          else
            links.concat(change_link(index))
          end
        else
          links.concat(create_link(index))
        end
        if index.not_even_admited_interupt?
          links.concat(interupt_link(index))
        end
        if index.interupt_waits_for_confirmation?
          links.concat(confirm_interupt_link(index)) 
        end
        if index.interupted?
          links.concat(end_interupt_link(index))
          status_class = 'ends_interupt'
        end
        if index.claimed_for_final_exam?
          links.concat(final_exam_link(index))
        end
      end
    end
    info.concat(div_tag("#{index.study.name}", {:class => 'smallinfo'}))
    info.concat(div_tag("#{index.year}. #{_('year')}", {:class => 'smallinfo'}))
    info.concat(div_tag(index.status, {:class => ['smallinfo',
      status_class].join(' ')}))
    if index.interupted?
      info.concat(interupt_to_info(index))
    elsif study_plan 
      info.concat(div_tag(study_plan.status, {:class => 'smallinfo'}))
    end
    info.concat(content_tag('span', student_link(index), {:id => 
      "link#{index.id}", :class => 'printable'}))
    unless links.empty?
      info = menu_link(index).concat(info)
      links.concat('&nbsp;')
    else
      info = smaller_info_div('&nbsp;').concat(info)
    end
    menu_line(links, "index_menu_#{index.id}") +
      info_line(info, index.line_class, "student_detail_#{index.id}") +
      form_line("index_form_#{index.id}")
  end 

  # prints code to switch old student link to new one
  def redraw_student(index)
    update_element_function("index_line_#{index.id}", :content => student_action_link(index))
  end

  # prints students scholarship
  def print_scholarship(index)
    ScholarshipCalculator.scholarship_for(index.student)
  end

  # prints finish link
  def finish_link(index)
    if index.finished? 
      menu_div(link_to_remote_with_loading(_('unfinish study'),
        :url => {:action => 'unfinish', :controller => 'students', 
        :id => index}, :update => "index_form_#{index.id}"))
    else 
      menu_div(link_to_remote_with_loading(_('finish study'), 
        :url => {:action => 'time_form', :controller => 'students', 
        :form_action => 'finish', :id => index}, :update =>
        "index_form_#{index.id}"))
    end
  end
 
  # prints link to switch study form
  def switch_link(index)
    menu_div(link_to_remote_with_loading( _('switch study'), :url => 
      {:action => 'time_form', :controller => 'students', :form_action => 
      'switch_study', :id => index}, :update => "index_form_#{index.id}"))
  end

  # prints interupt link
  def interupt_link(index)
    menu_div(link_to(_('interrupt study'), {:action => 'index', 
      :controller => 'interupts', :id => index}))
  end

  # prints confirm interupt link
  def confirm_interupt_link(index)
    menu_div(link_to_remote_with_loading(_('confirm interrupt'), :url =>
      {:action => 'time_form', :controller => 'students', :form_action => 
      'confirm', :form_controller => 'interupts', :id => index, :date =>
      index.interupt.start_on}, :update => "index_form_#{index.id}"))
  end

  # prints end interupt link
  def end_interupt_link(index)
    menu_div(link_to_remote_with_loading(_('end interrupt'), :url =>
      {:action => 'time_form', :controller => 'students', :form_action => 
      'end', :form_controller => 'interupts', :id => index, :date =>
      index.interupt.end_on}, :update => "index_form_#{index.id}"))
  end

  # prints link to change study plan
  def change_link(index)
    menu_div(link_to(_('change SP'), {:action => 'change', :controller => 
      'study_plans', :id => index.student}))
  end

  # prints link to create new study plan
  def create_link(index)
    menu_div(link_to(_('create SP'), :action => 
      'create_by_other', :controller => 'study_plans', :id =>
      index.student))
  end

  # prints link to create final exam term
  def final_exam_link(index)
    menu_div(link_to_remote_with_loading(_('final exam term'), :url => {:action =>
      'new', :controller => 'final_exam_terms', :id => index}, :evaluate => true))
  end

  # prints lint to interupt study
  def confirm_interupt_link(index)
    menu_div(link_to_remote_with_loading( _('confirm interupt'), {:url =>
      {:action => 'confirm', :controller => 'interupts', :id => index},
      :evaluate => true}))
  end

  # prints link to supervise scholarship
  def supervise_scholarship_link(index)
    menu_div(link_to_remote_with_loading(_('supervise scholarship'), :url =>
      {:controller => 'students', :action => 'supervise_scholarship_claim',
      :id => index}, :evaluate => true))
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

  # prints menu link
  def menu_link(index)
    code = <<-CODE
    Element.toggle('index_menu_#{index.id}', 'index_form_#{index.id}');
    CODE
    smaller_info_div(link_to_function(_('actions'), code))
  end

  # prints link to student detail
  def student_link(index)
    link = link_to_remote_with_loading(index.student.display_name, :url => {:action =>
      'show', :controller => 'students', :id => index}, :evaluate => true)
    if index.close_to_interupt_end_or_after?
      link = span_tag('!', :class => 'red').concat(link)
    end
    link
  end

  # prints line with student informations
  def info_line(info, line_class, id)
    div_tag(info, :class => ['student_detail', line_class].join(' '), :id => id)
  end

  # prints line with menu links
  def menu_line(links, id)
    div_tag(links, :id => id, :style => 'display: none', :class => 'menu_line')
  end

  # prints empty form line
  def form_line(id)
      div_tag('', :id => id, :style => 'display: none', :class => 'form_line')
  end

  def pass_link(what, index)
    action = 'pass_' + what.to_s
    url = {:action => 'time_form', :controller => 'students',
           :form_action => action, :id => index, :day => true}
    menu_div(link_to_remote_with_loading(_(action),
             :update => "index_form_#{index.id}", :url => url))
  end

  # prints month year form
  def date_form(options)
    date = options[:date] ? Time.parse(options.delete(:date)) : Date.today
    result = [form_remote_with_loading(options)]
    result << submit_tag(_(options[:url][:action].humanize))
    result << select_day(date) if options[:day]
    result << select_month(date, :use_month_numbers => true)
    result << select_year(date, :start_year => 2000)
    result << end_form_tag
    result.join('&nbsp;')
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
    opts = {:include_empty => options[:include_empty], :accredited => true}
    unless options[:user].has_role?('vicerector')
      opts[:faculty] = options[:user].person.faculty
    end
    select_options = coridor_options(opts)
    content_tag('select', select_options, {'id' => "filter_by_coridor", 
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

  def interupt_to_info(index)
  div_tag("#{_('to')} #{index.interupt.end_on.strftime('%d.%m.%Y')}",
         {:class => 'smallinfo'})
  end
  
  def list_links
  links = ''
  links << print_link(_('print this list'))
  links << '&nbsp;'
  links << link_to(_('export_xls'), {:action => 'list_xls'})
  end

  def back_to_list
    "Element.show('people_list', 'search'); Element.remove('student_detail')"
  end

  def back_and_remove_from_list(index)
    %{
      Element.remove('index_line_#{index.id}');
      Element.remove('student_detail');
      Element.show('people_list', 'search');
    }
  end
end
