# TODO move all ids methods to corresponding models
module ApplicationHelper
  
  def print_copyright 
    "designed by GravaStar &nbsp;"
  end

# prints department options
  def department_options(options = {})
    options_for_select(Department.for_select(options))
  end
  
  # prints corridor options 
  def coridor_options(options = {})
    options_for_select(Coridor.for_select(options))
  end
  
  # prints faculty options
  def faculty_options(options = {})
    options_for_select(Faculty.for_select(options))
  end
  
  # returns all years options
  def year_options
    options_for_select([['---', '0'], [_("1. year"), 1], [_("2. year"), 2], \
      [_("3. year"), 3], [_('x'), 4]])
  end
  
  # returns all statuses options
  def status_options
    options_for_select([['---', '0'], [_("SP not admited"), 1], \
      [_("SP admited"), 2], [_("SP approved by tutor"), 3], \
      [_("SP approved by leader"), 4], [_('SP approved by dean'), 5]])
  end
  
  # returns all study statuses options
  def study_status_options
    options_for_select([['---', '0'], [_("studying"), 1], \
      [_("finished"), 2], [_("interupted"), 3], [_('absolved'), 4], [_('continue'), 5]])
  end
  
  # returns all form options
  def form_options
    options_for_select([['---', '0'], [_("present"), 1], \
      [_("combined"), 2]])
  end

  def sex_select(model, method)
    select model, method, [[_("male"), 'M'],[_("female"), 'F']]
  end

  # returns yes or no options
  def yes_no_options
    [[_('yes'), 1], [_('no'), 2]]
  end
  
  # prints errors for object
  def errors_for(object)
    unless object.errors.empty?
      tb = _("There were errors in your input")
      tb << content_tag('ul',
      object.errors.to_a.map {|attr, message| content_tag('li',
      _(message))}.join(' '))
      content_tag('div', tb)
    end
  end
  
  # get language ids
  def language_options
    LanguageSubject.find_all.map {|l| [l.name, l.id]}
  end
  
  # get study ids
  def study_ids
    Study.find_all.map {|s| [s.name, s.id]}
  end
  
  # get coridor ids
  def coridor_ids(faculty)
    if faculty.is_a?(Faculty)
      faculty = faculty.id
    end
    [['---', '0']].concat(Coridor.find_all_by_faculty_id(faculty).map {|s|
      [truncate(s.name, 40), s.id]})
  end
  
  # get title_before ids
  def title_before_ids
    arr = [['---', '0']]
    arr.concat(Title.find_all(['prefix = ?', 1]).map {|s| [s.label, s.id]})
    return arr
  end
  
  # get title_before ids
  def title_after_ids
    arr = [['---', '0']]
    arr.concat(Title.find_all(['prefix = ?', 0]).map {|s| [s.label, s.id]})
    return arr
  end
  
  # get role ids
  def role_ids(collection)
    collection.map {|s| [s.name, s.id]}
  end
  
  # prints notice from flash
  def print_notice
    if @flash['notice']
      content_tag('div', @flash['notice'], :class => 'notice')
    end 
  end
  
  # get index ids
  def index_ids
    Student.find(:all).map {|s| [s.display_name, s.index.id]}
  end
  
  # get subject ids
  def subject_ids
    Subject.find(:all).map {|s| [s.label, s.id]}
  end
  
  # get voluntary subjects for corridor 
  def seminar_ids(coridor)
    if coridor.is_a? Coridor
      coridor = coridor.id
    end
    arr = []
    arr.concat(Coridor.find(coridor).seminar_subjects.map {|s|
      [truncate(s.subject.label, 40), s.subject_id]})
  end
  
  # returns approve word for statement result
  def approve_word(result)
    [ _("canceled"), _("approved"), _('approved with earfull')][result]
  end
  
  # prints approve form
  def approve_forms(document)
    if statement = document.index.statement_for(@user)
      approve_form(document, statement)
    end
  end
  
  # prints atestation links
  def atestation_links(study_plan)
    if study_plan.waits_for_actual_atestation?
      atestation_link(study_plan)
    end
  end
  
  # prints statements approvement 
  def print_statements(approvement)
    unless approvement.nil?
      print_statement(approvement.tutor_statement, _("tutor statement")) +
      print_statement(approvement.leader_statement, _("leader statement")) +
      print_statement(approvement.dean_statement, _("dean statement") ) 
    end
  end
  
  # prints atestaion subject line wihch depends on finishing of the subject
  def atestation_subject_line(plan_subject, atestation_term)
    content = ''
    if plan_subject.finished? && (plan_subject.finished_on <= atestation_term)
      content << content_tag('div', 
        plan_subject.finished_on.strftime('%d. %m. %Y'), :class => 'info')
      html_class = ''
    else
      content << content_tag('div', "#{plan_subject.finishing_on}.
      #{_('semester')}", :class => 'info')
      html_class = 'red'
    end
    content << plan_subject.subject.label
    content_tag('li', content, :class => html_class)
  end
  
  # prints link to remote with apearing and disapearing of the loading _
  # you should say if it's evaluating response by setting options[:evaluate]
  # to true, or updating by setting options[:update]
  def link_to_remote_with_loading(name, options = {}, html_options = {})
    options = set_remote_options(options)
    link_to_remote(name, options, html_options)
  end
  
  # prints form tag with loading apearing and disapearing
  # also evaluate remote response is built in
  def form_remote_with_loading(options)
    options = set_remote_options(options)
    options[:html] = {:autocomplete => "off"} 
    options[:html][:style] = 'display: inline;' if options.delete(:inline)
    form_remote_tag(options)
  end
	
  # returns array of the time by quarter from start time to end time
	def str_time_select(start_time = 8, stop_time = 16)
		items = []
		(start_time..stop_time-1).each do |hour|
			['00', '15', '30', '45'].each {|minute| items << ("#{hour.to_s}:#{minute}")}
		end
		items << "#{stop_time.to_s}:00"
		return items
	end

  # prints birth number if user has faculty secretary role 
  def birth_number_line(student)
    if @user.has_role?('faculty_secretary') && student.birth_number
      content_tag('li', 
        "#{long_info_helper(student.birth_number)}#{_('Birth number')}:")
    end
  end

  # prints main menu
  def main_menu
    links = []
    if @user.person.is_a?(Student) and @student 
      if @student.index.study_plan && @student.index.study_plan.approved? 
        links << link_to_unless_current(_("probation terms"), :controller =>
          'probation_terms'){} 
      end 
      links << link_to_unless_current(_("study plan"), :controller => 'study_plans',
        :action => 'index'){} 
      #links << link_to_unless_current(_("contacts"), :controller => 'address', :action => 'edit'){}
      links << link_to_unless_current(_("scholarship"), :controller => 'scholarships',
        :action => 'list'){} 
    else 
      if @user.has_one_of_roles?(['admin', 'faculty_secretary', 'dean']) 
        links << link_to_unless_current(_("candidates"), :controller => 'candidates'){} 
        links << link_to_unless_current(_("exam_terms"), :controller => 'exam_terms'){} 
        links << prepare_scholarship_link
        links << link_to_unless_current(_("exams"), :controller => 'exams'){} 
      elsif @user.has_one_of_roles?(['faculty_secretary', 'tutor', 'department_secretary']) 
        links << link_to_unless_current(_("probation terms"), :controller =>
          'probation_terms'){} 
        links << link_to_unless_current(_("exams"), :controller => 'exams'){} 
      end 
      links << link_to_unless_current(_("students"), :controller => 'students'){} 
    end 
    links << link_to_unless_current(_("logoff"), {:controller => 'account', :action => 'logout'}, :confirm =>  _("do you really want to") + ' ' +
      _("logoff") + '?'){} 
    links.flatten.join("\n")
  end
  
  # prints birth place for student if he has it
  def birth_place_line(student)
    if student.birth_place
      content_tag('li',
        "#{long_info_helper(student.birth_place)}#{_('Birth place')}:")
    end
  end

  # prints birth place for student if he has it
  def birth_date_line(student)
    if student.birth_on
      content_tag('li',
        %{
          #{long_info_helper(student.birth_on.strftime('%d.%m.%Y'))}
          #{_('Birth date')}:
        })
    end
  end

  def attribute_line(object, name, meth = nil)
    if @user.has_one_of_roles?(['faculty_secretary', 'student'])
      long_info_helper(edit_link(object, name, meth), :id => name)
    else
      label = object.send(name)
      label = label.send(meth) if label && meth
      long_info_helper(label)
    end
  end

  def save_form(name)
    form_remote_tag(:url => {:action => "save_#{name}"},
                        :complete => evaluate_remote_response,
                        :after => loader_image("#{name}_submit"))
  end

  def ok_submit(name)
    content_tag(:span, image_submit_tag('ok'), :id => "#{name}_submit", 
                :class => 'noborder') 
  end

  # prints print link
  def print_link(text = _('print'))
    link_to_function(text, 'window.print()')
  end

  private 
  
  # sets options for remote tags
  def set_remote_options(options)
    options[:loading] = visual_effect(:appear, 'loading', :to => 0.6, 
      :duration => 0.1)
    options[:interactive] = visual_effect(:fade, "loading", :from => 0.6,
      :duration => 0.1) 
    options[:complete] = evaluate_remote_response if options[:evaluate] 
    return options
  end
  
  # prints statement
  def print_statement(statement, statement_type)
    result = ''
    options = {}
    if statement
      result << approve_word(statement.result)
      if statement.note && !statement.note.empty?
        result << ", #{_('with note')}: #{statement.note}"
        options[:class] = 'higher'
      end
      result = content_tag('div', statement.created_on.strftime('%d. %m. %Y'),
      :class => 'info') + div_tag(result)
    end
    return content_tag('li', "#{div_tag(result, :class => 'long_info')}
    #{statement_type}", options)
  end
  
  # prints atestation link
  def atestation_link(study_plan)
    link_to_remote_with_loading(_("see atestation informations"), {:url => {:controller =>
      'study_plans', :action => 'atest', :id => study_plan}, :evaluate => true},
      {:id => "atestation_link"})
  end
  
  # prints approvement link
  def approve_form(document, statement)
    statement.class.to_s =~ /(.*)Statement/
    person = $1.downcase
    if document.is_a?(StudyPlan) && document.approved? && 
      document.waits_for_actual_atestation?
      action = 'confirm_atest'
      title = _("atest like #{person}")
      options = [[_("approve"), 1], [_("approve with earfull"), 2], [_("cancel"), 0]]    
    else
      action = 'confirm_approve'
      title = _("approve like #{person}")
      options = [[_("approve"), 1], [_("cancel"), 0]]
    end
    render(:partial => 'shared/approve_form', :locals => {:document => document,
      :title => title, :options => options, :action => action, :statement => 
      statement})
  end
  
  # prints methodology link
  def methodology_link(disert_theme)
    content_tag('li', link_to_remote_with_loading(
      _("methodology file (opens new window)"), {:url => {:controller => 
      'disert_themes', :action => 'file_clicked', :id => disert_theme},
      :evaluate => true}), {:id => "methodology_link#{disert_theme.id}"})
  end
  
  # prints atestation detail link
  def atestation_detail(study_plan)
    if @student
      link_to_remote_with_loading(_("additional information for next atestation"),
        {:controller => 'study_plans', :action => 'atestation_details', :id => 
        study_plan, :evaluate => true}, {:id => "detail_link#{study_plan.id}"})
    else
      atestation_links(study_plan)
    end
  end
  
  def detail_links(user, index)
    if user.non_student?
      content = []
      content << div_tag(link_to_function(_("back"), back_to_list,
                                          :id => 'back_link'), :class => 'left')
      content << link_to_function(_("back and remove from list"), 
                                  back_and_remove_from_list(index),
                                  :id => 'back_remove_link')
      div_tag(content.join(' '), :class => 'links')
    end
  end
  
  # prints small info div 
  # TODO redone with div on end
  def long_info_helper(content, options={})
     options[:class]='long_info'
     content_tag('div', content, options)
  end
  
  # prints div tag
  def div_tag(content, options = {})
    content_tag('div', content, options)
  end

  # prints span tag
  def span_tag(content, options = {})
    content_tag('span', content, options)
  end

  # prints div with smallerinfo class with content inside
  def smaller_info_div(content)
    div_tag(content, {:class => 'smallerinfo'})
  end

  def longer_info_div(content)
    div_tag(content, {:class => 'longerinfo'})
  end

  def date_info_div(content)
    div_tag(content, {:class => 'dateinfo'})
  end

  # prints div with smallerinfo class with content inside
  def menu_div(content)
    div_tag(content, {:class => 'menu'})
  end

  # prints div with smallinfo class with content inside
  def small_info_div(content)
    div_tag(content, {:class => 'smallinfo'})
  end

  # prints div with info class
  def info_div(content)
    div_tag(content, {:class => 'info'})
  end

  # prints interupt finish line
  def interupt_finish_line(index)
    finished_on = info_div(index.interupt.finished_on.strftime('%d.%m.%Y'))
    content_tag('li', finished_on + _('finished on'))
  end

  def prepare_scholarship_link
    link_to_unless_current(_("scholarship"), :controller => 'scholarships',
                          :action => 'prepare'){} 
  end

  def edit_link(object, name, meth = nil)
    label = object.send(name)
    label = label.send(meth) if label && meth
    cntr = object.class.to_s.underscore.pluralize
    link_to_remote("#{changer_image(name)}#{label}",
                   {:update => name,
                   :after => loader_image("#{name}_changer"),
                   :url => {:controller => cntr, 
                           :action => "edit_#{name}", :id => object.id}},
                   :id => "#{name}_link",
                   :class => 'change_field')
  end

  def contact_link(index)
    link_to_remote(image_tag('change.png'), 
                  {:update => "contacts_form_#{index.id}",
                   :after => loader_image('contact_link'),
                   :complete => evaluate_remote_response,
                   :url => {:controller => 'address', :action => 'edit', 
                           :id => index.id}}, :id => 'contact_link')
  end

  def street_link(index)
    link_to_remote(image_tag('change.png'), 
                   :update => "address_street_field_form_#{index.id}",
                   :complete => evaluate_remote_response,
                   :url => {:controller => 'address', 
                           :action => 'edit_street', :id => index.id } )
  end

  def desc_number_link(index)
    link_to_remote(image_tag('change.png'), 
                   :update => "address_desc_number_field_form_#{index.id}",
                   :complete => evaluate_remote_response,
                   :url => {:controller => 'address', 
                           :action => 'edit_desc_number', :id => index.id})
  end

  def city_link(index)
    link_to_remote(image_tag('change.png'), 
                   :update => "address_city_field_form_#{index.id}",
                   :complete => evaluate_remote_response,
       		   :url => {:controller => 'address', :action => 'edit_city', :id => index.id})
  end

  def zip_link(index)
    link_to_remote(image_tag('change.png'), 
                   :update => "address_zip_field_form_#{index.id}",
                   :complete => evaluate_remote_response,
                   :url => {:controller => 'address', 
                           :action => 'edit_zip', :id => index.id})
  end

  def street_line(student)
    street = student.address ? student.address.street : ''
    long_info_helper("#{street_link(student.index)} #{street}", 
                     :id => 'address_street_field')
  end

  def desc_number_line(student)
    desc_number = student.address ? student.address.desc_number : ''
    long_info_helper("#{desc_number_link(student.index)} #{desc_number}", 
                     :id => 'address_desc_number_field')
  end

  def city_line(student)
    city = student.address ? student.address.city : ''
    long_info_helper("#{city_link(student.index)} #{city}", 
                     :id => 'address_city_field')
  end

  def zip_line(student)
    zip = student.address ? student.address.zip : ''
    long_info_helper("#{zip_link(student.index)} #{zip}", 
                     :id => 'address_zip_field')
  end

  private 
  
  def loader_image(field)
    "Element.replace('#{field}', '#{image_tag('loader.gif', :size => '12x12')}')"
  end

  def changer_image(name)
    image_tag('change.png', :id => "#{name}_changer")
  end
end


