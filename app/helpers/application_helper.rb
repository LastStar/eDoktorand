# TODO move all ids methods to corresponding models
module ApplicationHelper
  
  # TODO remove from form controller
  # prints department options
  def department_options(options = {})
    options_for_select(Department.for_select(options))
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
      tbc = ""
      tbc << "#{_("There were errors in your input")}"
      tbc << content_tag('ul',
      object.errors.to_a.map do |attr, message|
        content_tag('li', _(message))
      end.join(' '))
      content_tag('div',tbc)
    end
  end

  # get language ids
  def language_options
    LanguageSubject.find(:all).map {|l| [l.name, l.id]}
  end
  
  # get study ids
  def study_ids
    Study.find(:all).map {|s| [s.name, s.id]}
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
    arr.concat(Title.find(:all, :conditions => {:prefix => 1}).map {|s| [s.label, s.id]})
    return arr
  end
  
  # get title_before ids
  def title_after_ids
    arr = [['---', '0']]
    arr.concat(Title.find(:all, :conditions => {:prefix => 0}).map {|s| [s.label, s.id]})
    return arr
  end
  
  # get role ids
  def role_ids(collection)
    collection.map {|s| [s.name, s.id]}
  end
  
  # prints notice from flash
  def print_notice
    if flash[:notice]
      content_tag('div', flash[:notice], :class => 'notice')
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
  def approve_forms(user, document)
    if statement = document.index.statement_for(user)
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
    if plan_subject.finished?
      content << content_tag('div', plan_subject.finished_on.strftime('%d. %m. %Y'), :class => 'info')
      html_class = ''
    else
      content << content_tag('div', "#{plan_subject.finishing_on}. #{_('semester')}", :class => 'info')
      html_class = 'red'
    end
    content << plan_subject.subject.label
    content_tag('li', content, :class => html_class)
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
    if @user.has_one_of_roles?(['faculty_secretary', 'student']) && student.birth_number
      content_tag('li', 
              long_info_helper(student.birth_number) + _('Birth number') + ' :',
                 :class => 'nonprintable')
    end
  end

  # prints birth number if user has faculty secretary role 
  def birth_on_line(student)
    if @user.has_one_of_roles?(['faculty_secretary', 'student']) && student.birth_on
      content_tag('li', 
              long_info_helper(student.birth_on) + _('Birth on') + ':',
                 :class => 'nonprintable')
    end
  end

  # prints main menu
  def main_menu
    links = [print_link(image_tag('printer.png', :alt => _('print'), 
                                  :size => '12x12' ))]
    if @user.person.is_a?(Student) and @student 
      links << student_menu
    else
      if @user.has_role?('examinator')
        links << link_to_unless_current(_("exams"), :controller => 'exams'){}
      elsif @user.has_one_of_roles?(['admin', 'faculty_secretary', 'dean']) 
          links << link_to_unless_current(_("candidates"), :controller => 'candidates', :category => 'lastname'){} 
          links << link_to_unless_current(_("exam_terms"), :controller => 'exam_terms'){} 
          links << link_to_unless_current(_("exams"), :controller => 'exams'){}
          links << prepare_scholarship_link
          links << link_to_unless_current(_('diplomas'), :controller => 'diploma_supplements') {}
          links << link_to_unless_current(_('tutors'), :controller => 'tutors') {}
          links << link_to_unless_current(_('coridors'), :controller => 'coridors') {}
      elsif @user.has_one_of_roles?(['tutor', 'leader', 'department_secretary']) 
        if @user.has_role?('board_chairman')
          links << link_to_unless_current(_("candidates"), :controller => 'candidates', :category => 'lastname'){}
        end
        if @user.has_role?('department_secretary')
          links << link_to_unless_current(_("candidates"), :controller => 'candidates', :action => 'list', :category => 'lastname'){} 
          links << prepare_scholarship_link
        end
        links << link_to_unless_current(_("probation terms"), 
                                        :controller => 'probation_terms'){} 
        links << link_to_unless_current(_("exams"), :controller => 'exams'){}
      end 
      links << link_to_unless_current(_("students"), 
                                      :controller => 'students'){}
    end
    links << link_to_unless_current(_("logoff"), 
                                    {:controller => 'account', 
                                     :action => 'logout'}, 
                                     :confirm =>  _("do you really want to") + 
                                     ' ' + _("logoff") + '?'){} 
    links.flatten.join("\n")
  end

  def student_menu
    result = []
    if @student.index.study_plan && @student.index.study_plan.approved? 
      result << link_to_unless_current(_("probation terms"), 
                                      :controller => 'probation_terms'){} 
    end
    result << link_to_unless_current(_("study plan"),
                                     :controller => 'study_plans',
                                     :action => 'index'){}
    result << link_to_unless_current(_("scholarship"),
                                      :controller => 'scholarships',
                                      :action => 'student_list'){}
    result
  end
  
  # prints birth place for student if he has it
  def birth_place_line(student)
    if student.birth_place
      content_tag('li',
        long_info_helper(student.birth_place) + _('Birth place') + ':')
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

  def save_form(name, &proc)
    form_remote_tag(:url => {:action => "save_#{name}"},
                    :complete => evaluate_remote_response,
                    :after => loader_image("#{name}_submit"),
                    &proc)
  end

  def ok_submit(name)
    content_tag(:span, image_submit_tag('ok.png'),
                :id => "#{name}_submit", 
                :class => 'noborder') 
  end

  # prints print link
  def print_link(text = _('print'))
    link_to_function(text, 'window.print()')
  end

  private 
  
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
    link_to_remote(_("see atestation informations"), 
                   {:url => {:controller => 'study_plans', :action => 'atest',
                             :id => study_plan},
                   :loading => 
                    "$('atestation_link').innerHTML = '%s'" % _('working...'),
                   :complete => evaluate_remote_response},
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
    link_to_remote(_("methodology file (opens new window)"),
                  {:url => {:controller => 'disert_themes', 
                           :action => 'file_clicked', :id => disert_theme},
                    :complete => evaluate_remote_response},
                  {:id => "methodology_link#{disert_theme.id}"})
  end
  
  # prints atestation detail link
  def atestation_detail(study_plan)
    if @student
      link_to_remote(_("additional information for next atestation"),
                    {:url => {:controller => 'study_plans', 
                      :action => 'atestation_details',
                      :id => study_plan, :evaluate => true},
                    :complete => evaluate_remote_response},
                    {:id => "detail_link#{study_plan.id}"})
    else
      atestation_links(study_plan)
    end
  end
  
  def detail_links(user, index)
    if user.non_student?
      content = []
      content << link_to_function(_("back"),
                                  back_to_list,
                                  :id => 'back_link')
      content << link_to_function(_("back and remove from list"), 
                                  back_and_remove_from_list(index),
                                  :id => 'back_remove_link')
      content.join(' ')
    end
  end
  
  # prints small info div 
  # TODO redone with div on end
  def long_info_helper(content, options={})
    if options[:class]
      options[:class].concat(' long_info')
    else
      options[:class] = 'long_info'
    end
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

  def date_info_div(content)
    div_tag(content, {:class => 'dateinfo'})
  end

  # prints div with smallerinfo class with content inside
  def menu_div(content)
    div_tag(content, {:class => 'menu'})
  end

  # prints div with smallerinfo class with content inside
  def menu_tr(content)
    content_tag('tr', content,{:class => 'menu'})
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
  def interupt_finish_line(interupt)
    finished_on = info_div(interupt.finished_on.strftime('%d.%m.%Y'))
    content_tag('li', finished_on + _('finished on'))
  end

  def prepare_scholarship_link
    link_to_unless_current(_("scholarship"), :controller => 'scholarships',
                          :action => 'index'){} 
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

  def first_upper(string)
    f = string[0, 1]
    l = string[1..-1]
    f.upcase + l
  end

  def first_lower(string)
    f = string[0, 1]
    l = string[1..-1]
    f.downcase + l
  end

  def display_name_options(people)
    options_for_select(people.map {|p| [p.display_name, p.id]})
  end

  def final_exam_term_link(user, index)
    if user.has_role?('faculty_secretary') && !index.final_exam_invitation_sent?
      opts = {:url => {:controller => 'final_exam_terms', :action => 'new', 
                      :id => index},
              :complete => evaluate_remote_response}
    elsif index.final_exam_term
      opts = {:url => {:controller => 'final_exam_terms', :action => 'show', 
                       :id => index.final_exam_term.id},
              :complete => evaluate_remote_response}
    end
    link_to_remote(_('final exam term'), opts, :id => 'final_exam_link') if opts
  end

  def defense_term_link(user, index)
    if user.has_role?('faculty_secretary') && !index.defense_invitation_sent?
      opts = {:url => {:controller => 'defenses', :action => 'new', 
                      :id => index},
              :complete => evaluate_remote_response}
    elsif index.defense
      opts = {:url => {:controller => 'defenses', :action => 'show', 
                       :id => index.defense.id},
              :complete => evaluate_remote_response}
    end
    link_to_remote(_('defense'), opts, :id => 'defense_link') if opts
  end

  def hide_link(element, text = _('hide'))
    link_to_function(text, "Element.hide('#{element}')")
  end

  def add_en_link(id, i)
    link_to_remote(image_tag('plus.png'),
                   :url => {:controller => 'study_plans',
                           :action => 'add_en',
                           :id => id,
                           :final_area_id => i},
                   :update => 'final_area_en'+i.to_s)
  end

  def add_disert_theme_en_link(disert_theme)
    link_to_remote(image_tag('plus.png'),
                   :url => {:controller => 'disert_themes',
                           :action => 'add_en',
                           :disert_theme => disert_theme},
                   :update => "disert_theme_title_en")
  end
  
  def save_disert_theme_form(disert_theme, &proc)
    form_remote_tag(:url => {:controller => 'disert_themes',
                            :action => 'save_en',
                            :disert_theme => disert_theme},
                    :update => "disert_theme_title_en", &proc)
  end

  def save_final_area_form(id, final_area_id, &proc)
    form_remote_tag(:url => {:controller => 'study_plans',
                            :action => 'save_en',
                            :id => id,
                            :final_area_id => final_area_id},
                    :update => 'final_area_en' + final_area_id.to_s,
                    &proc)
  end

  def disert_theme_line(disert_theme)
    "(en) " + if disert_theme.title_en == nil || disert_theme.title_en == "" 
      add_disert_theme_en_link(disert_theme) 
    else 
      "#{disert_theme.title_en}" 
    end 
  end

  def student_name_line(student)
    if @user.has_role?('faculty_secretary')
      attribute_line(student, :display_name) + _('Full name') + ':'
    else
      long_info_helper(student.display_name, :class => 'printable') + 
        _('Full name') + ':'
    end
  end

  def remove_line
    link_to_function(image_tag('close.png'), "$('coridor_subject_form').remove()")
  end
  
  def student_tutor_line(index)
    if @user.has_role?('faculty_secretary')
      attribute_line(index, :tutor, :display_name) + _('Tutor') + ':'
    else
      long_info_helper(index.tutor.display_name, :class => 'printable') + 
        _('Tutor') + ':'
    end
  end

  def literature_review_link(disert_theme)
    path = "/pdf/literature_review/%i.pdf" % disert_theme.id
    if File.exists?("#{RAILS_ROOT}/public/" + path)
      link_to _('literature review file'), path, :popup => true
    end
  end

  def self_report_link(disert_theme)
    path = "/pdf/self_report/%i.pdf" % disert_theme.id
    if File.exists?("#{RAILS_ROOT}/public/" + path)
      link_to _('self report file'), path, :popup => true
    end
  end

  def disert_theme_link(disert_theme)
    path = "/pdf/disert_theme/%i.pdf" % disert_theme.id
    # TODO remove after fixing upload
    # if File.exists?("#{RAILS_ROOT}/public/" + path)
      link_to _('disert theme file'), path, :popup => true
    #end
  end

  def spinner_image(js_id = 'spinner')
    image_tag('loader.gif', :id => js_id, :style => 'display: none')
  end

  # TODO use on more places
  # returns select options for any labeled objects
  def label_options(objects)
    options_for_select(objects.map{|o| [o.label, o.id]})
  end

  # returns form for approving
  def approve_document_form(document, action, &proc)
    controller = document.class.to_s.underscore.pluralize
    form_remote_tag(:url => {:controller => controller,
                            :action => action,
                            :id => document},
                    :loading => "$('submit-button').value = '%s'" % _('working...'),
                    :complete => evaluate_remote_response,
                    &proc)

  end
private
  
  def loader_image(field)
    "Element.replace('#{field}', '#{image_tag('loader.gif', :size => '12x12')}')"
  end

  def changer_image(name)
    image_tag('change.png', :id => "#{name}_changer")
  end
end
