  # TODO move all ids methods to corresponding models
module ApplicationHelper
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
  def language_ids
    Language.find_all.map {|l| [l.name, l.id]}
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
  # get tutor ids
  # if options['coridor'] setted only for this coridor
  def tutor_ids(options = {})
    if options[:coridor]
      ts = Tutorship.find_all_by_coridor_id(options[:coridor].id)
    else
      ts = Tutorship.find(:all)
    end
    ts.map {|ts| [ts.tutor.display_name, ts.tutor.id]}
  end
  # get examinator ids
  def examinator_ids(faculty)
    # bloody hack evarybody should have faculty 
    faculty = faculty.id if faculty.is_a?(Faculty)
    Tutor.find(:all).select{|t| t.faculty && t.faculty.id == faculty}.map {|p| [p.display_name, p.id]}
  end
  # get examinator ids
  # allows null
  def examinator_null_ids(faculty)
    arr = [['---', '0']]
    faculty = faculty.id if faculty.is_a?(Faculty)
    # bloody hack evarybody should have faculty 
    arr.concat(Tutor.find(:all).select{|t| t.faculty && t.faculty.id ==
    faculty}.map {|p| [p.display_name, p.id]})
  end
  # get index ids
  def index_ids
    Student.find(:all).map {|s| [s.display_name, s.index.id]}
  end
  # get subject ids
  def subject_ids
    Subject.find(:all).map {|s| [s.label, s.id]}
  end
  # get language  subject ids
  def language_subject_ids
    LanguageSubject.find_all.map {|l| [l.subject.label, l.subject.id]}
  end
  # get voluntary subjects for corridor 
  def voluntary_ids(coridor)
    arr = [[_("external subject"), 0]]
    arr.concat(Coridor.find(coridor).voluntary_subjects.map {|s|
      [truncate(s.subject.label, 40), s.subject_id]})
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
    [ _("canceled"), _("approved")][result]
  end
  # prints approve form
  def approve_forms(study_plan)
    if statement = study_plan.index.statement_for(@user)
      if study_plan.approved? && !study_plan.index.disert_theme.approved?
        approve_form(study_plan.index.disert_theme, statement)
      else
        approve_form(study_plan, statement)
      end
    end
  end
  # prints atestation links
  def atestation_links(study_plan)
    if Atestation.actual_for_faculty(@user.person.faculty)
      atestation_link(study_plan)
    end
  end
  # prints statements approvement 
  def print_statements(approvement)
    print_statement(approvement.tutor_statement, _("Tutor statement")) +
    print_statement(approvement.leader_statement, _("Leader statement")) +
    print_statement(approvement.dean_statement, _("Dean statement") ) 
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
      html_class = 'unfinished'
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
# prints main menu
  def main_menu
    links = []
    if @session['user'].person.is_a?(Student) and @student 
      if !@student.index.study_plan 
        links << link_to(_("create study plan"), {:action => 'create', :id => @student}, 
          :confirm => _("Have you consulted your study plan with tutor. It is highly recomended")) 
        links << link_to_unless_current(_("contacts"), :controller => 'addresses', :action => 'edit'){}
      else
        links << link_to(_("change study plan"), {:action => 'change', :id => @student})
        if @student.index.study_plan.approved? 
          links << link_to_unless_current(_("probation terms"), :controller =>
            'probation_terms'){} 
          links << link_to_unless_current(_('interupt'), :controller => 'interupts'){}
        end 
        links << link_to_unless_current(_("study plan"), :controller => 'study_plans',
          :action => 'index'){} 
        links << link_to_unless_current(_("scholarship"), :controller => 'scholarships',
          :action => 'list'){} 
      end
        links << link_to_unless_current(_("contacts"), :controller => 'address', :action => 'edit'){}
    else 
      if @session['user'].has_one_of_roles?(['admin', 'faculty_secretary']) 
        links << link_to_unless_current(_("candidates"), :controller => 'candidates'){} 
        links << link_to_unless_current(_("exam_terms"), :controller => 'exam_terms'){} 
        links << link_to_unless_current(_("scholarship"), :controller => 'scholarships',
          :action => 'scholarship'){} 
        links << link_to_unless_current(_("exams"), :controller => 'exams'){} 
      elsif @session['user'].has_one_of_roles?(['faculty_secretary', 'tutor', 'department_secretary']) 
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
# prints code to switch old student link to new one
  def redraw_student(index)
    update_element_function("index_line_#{index.id}", :content => student_action_link(index))
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
    if statement
      result << approve_word(statement.result)
      if statement.note && !statement.note.empty?
        result << ", #{_('with note')}: #{truncate(statement.note, 30)}"
      end
      result = content_tag('div', statement.created_on.strftime('%d. %m. %Y'),
      :class => 'info') + result
    end
    return content_tag('li', "#{content_tag('div', result, :class => 'long_info')}
    #{statement_type}", :class => 'second')
  end
  # prints atestation link
  def atestation_link(study_plan)
    element = "approve_form#{study_plan.id}"
    link_to_remote_with_loading(_("see atestation informations"), {:controller =>
      'study_plans', :action => 'atest', :id => study_plan, :evaluate => true},
      {:id => element})
  end
  # prints approvement link
  def approve_form(document, statement)
    statement.class.to_s =~ /(.*)Statement/
    person = $1.downcase
    if document.is_a?(StudyPlan) && document.approved?
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
      statement, :controller => document.class.to_s.underscore.pluralize})
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
        study_plan, :evaluate => true}, {:id => 
        "detail_link#{study_plan.id}"})
    else
      atestation_links(study_plan)
    end
  end
  # prints small info div 
  def long_info_helper(content)
    content_tag('div', content, :class => 'long_info')
  end
  # prints div tag
  def div_tag(content, options = {})
    content_tag('div', content, options)
  end

end
