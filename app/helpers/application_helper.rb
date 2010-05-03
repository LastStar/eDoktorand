# TODO move all ids methods to corresponding models
module ApplicationHelper
  
  # prints link logout page
  def logout_link
    link_to_unless_current(image_tag('icons/door_in.png'), 
                          {:controller => 'account', 
                           :action => 'logout'}, 
                           :confirm =>  t(:message_29, :scope => [:txt, :helper, :application]) + 
                           ' ' + t(:message_30, :scope => [:txt, :helper, :application]) + '?')
  end

  # TODO remove from form controller
  # translates country code 
  def translate_country(code)
    I18n.translate(:countries)[code.to_sym]
  end
  
  # prints department options
  def department_options(options = {})
    options_for_select(Department.for_select(options))
  end
  
  def sex_select(model, method)
    select model, method, [[t(:message_0, :scope => [:txt, :helper, :application]), 'M'],[t(:message_1, :scope => [:txt, :helper, :application]), 'F']]
  end

  # returns yes or no options
  def yes_no_options
    [[t(:message_2, :scope => [:txt, :helper, :application]), 1], [t(:message_3, :scope => [:txt, :helper, :application]), 2]]
  end
  
  # prints errors for object
  def errors_for(object)
    unless object.errors.empty?
      tbc = ""
      tbc << "#{t(:message_4, :scope => [:txt, :helper, :application])}"
      tbc << content_tag('ul',
      object.errors.to_a.map do |attr, message|
        content_tag('li', message)
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
  
  # get specialization ids
  def specialization_ids(faculty)
    if faculty.is_a?(Faculty)
      faculty = faculty.id
    end
    [['---', '0']].concat(Specialization.find_all_by_faculty_id(faculty).map {|s|
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
  
  # returns approve word for statement result
  def approve_word(result)
    if result
      [ t(:message_6, :scope => [:txt, :helper, :application]), t(:message_7, :scope => [:txt, :helper, :application]), t(:message_8, :scope => [:txt, :helper, :application]), t(:interrupt, :scope => [:txt, :helper, :application])][result]
    end
  end
  
  # prints approve form
  def approve_forms(user, document)
    if statement = document.index.statement_for(user)
      approve_form(document, statement)
    end
  end
  
  # prints attestation links
  def attestation_links(study_plan)
    if study_plan.waits_for_actual_attestation?
      attestation_link(study_plan)
    end
  end
  
  # prints statements approval 
  def print_statements(approval)
    unless approval.nil?
      print_statement(approval.tutor_statement, t(:message_9, :scope => [:txt, :helper, :application])) +
      print_statement(approval.leader_statement, t(:message_10, :scope => [:txt, :helper, :application])) +
      print_statement(approval.dean_statement, t(:message_11, :scope => [:txt, :helper, :application]) ) 
    end
  end
  
  # prints attestation subject line which depends on finishing of the subject
  def attestation_subject_line(plan_subject, attestation_term)
    content = ''
    if plan_subject.finished?
      content << content_tag('div', plan_subject.finished_on.strftime('%d. %m. %Y'), :class => 'info')
      html_class = ''
    else
      content << content_tag('div', "#{plan_subject.finishing_on}. #{t(:message_12, :scope => [:txt, :helper, :application])}", :class => 'info')
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
              long_info_helper(student.birth_number) + t(:message_13, :scope => [:txt, :helper, :application]) + ' :',
                 :class => 'nonprintable')
    end
  end

  # prints birth number if user has faculty secretary role 
  def birth_on_line(student)
    if @user.has_one_of_roles?(['faculty_secretary', 'student']) && student.birth_on
      content_tag('li', 
              long_info_helper(student.birth_on) + t(:message_14, :scope => [:txt, :helper, :application]) + ':',
                 :class => 'nonprintable')
    end
  end

  # prints main menu
  def main_menu
    links = []
    if @user.person.is_a?(Student) and @student 
      links << student_menu
    else
      if @user.has_role?('examinator')
        links << link_to(t(:message_16, :scope => [:txt, :helper, :application]), :controller => 'exams')
      elsif @user.has_one_of_roles?(['admin', 'faculty_secretary', 'dean', 'vicerector']) 
          links << link_to(t(:message_66, :scope => [:txt, :helper, :application]), :controller => 'actualities') 
          links << link_to(t(:message_17, :scope => [:txt, :helper, :application]), :controller => 'candidates', :category => 'lastname') 
          links << link_to(t(:message_18, :scope => [:txt, :helper, :application]), :controller => 'exam_terms') 
          links << link_to(t(:message_19, :scope => [:txt, :helper, :application]), :controller => 'exams')
          links << link_to(t(:message_68, :scope => [:txt, :helper, :application]), :controller => 'final_exam_terms', :action => 'list')
          links << link_to(t(:message_70, :scope => [:txt, :helper, :application]), :controller => 'defenses', :action => 'list')
          links << prepare_scholarship_link
          links << link_to(t(:message_67, :scope => [:txt, :helper, :application]), :controller => 'examinators')
          links << link_to(t(:message_20, :scope => [:txt, :helper, :application]), :controller => 'diploma_supplements')
          links << link_to(t(:message_21, :scope => [:txt, :helper, :application]), :controller => 'tutors')
          links << link_to(t(:message_22, :scope => [:txt, :helper, :application]), :controller => 'specializations')
      elsif @user.has_one_of_roles?(['tutor', 'leader', 'department_secretary']) 
        if @user.has_role?('board_chairman')
          links << link_to(t(:message_23, :scope => [:txt, :helper, :application]), :controller => 'candidates', :category => 'lastname')
        end
        if @user.has_role?('department_secretary')
          links << link_to(t(:message_24, :scope => [:txt, :helper, :application]), :controller => 'candidates', :action => 'list', :category => 'lastname') 
          links << prepare_scholarship_link
        end
        links << link_to(t(:message_25, :scope => [:txt, :helper, :application]), 
                                        :controller => 'probation_terms') 
        links << link_to(t(:message_26, :scope => [:txt, :helper, :application]), :controller => 'exams')
      end 
      links << link_to(t(:message_27, :scope => [:txt, :helper, :application]), 
                                      :controller => 'students')
    end
    links << [print_link(image_tag('printer.png', :alt => t(:message_36, :scope => [:txt, :helper, :application]))), logout_link]
    links.flatten.join("\n")
  end

  def student_menu
    result = []
    if @student.index.study_plan && @student.index.study_plan.approved? 
      result << link_to(t(:message_31, :scope => [:txt, :helper, :application]), 
                                      :controller => 'probation_terms') 
    end
    result << link_to(t(:message_69, :scope => [:txt, :helper, :application]),
                                     :controller => 'study_plans',
                                     :action => 'requests')
    result << link_to(t(:message_32, :scope => [:txt, :helper, :application]),
                                     :controller => 'study_plans',
                                     :action => 'index')
    result << link_to(t(:message_33, :scope => [:txt, :helper, :application]),
                                      :controller => 'scholarships',
                                      :action => 'student_list')
    result
  end
  
  # prints birth place for student if he has it
  def birth_place_line(student)
    if student.birth_place
      content_tag('li',
        long_info_helper(student.birth_place) + t(:message_34, :scope => [:txt, :helper, :application]) + ':')
    end
  end

  # prints birth place for student if he has it
  def birth_date_line(student)
    if student.birth_on
      content_tag('li',
        %{
          #{long_info_helper(student.birth_on.strftime('%d.%m.%Y'))}
          #{t(:message_35, :scope => [:txt, :helper, :application])}:
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
                    :after => loader_image("#{name}_submit"),
                    &proc)
  end

  def ok_submit(name)
    content_tag(:span, image_submit_tag('ok.png'),
                :id => "#{name}_submit", 
                :class => 'noborder') 
  end

  # prints print link
  def print_link(text = t(:message_36, :scope => [:txt, :helper, :application]))
    link_to(text, '', :onclick => 'window.print()')
  end

  private 
  
  # prints statement
  #FIXME string extrapolation should be done better
  def print_statement(statement, statement_type)
    result = ''
    options = {}
    if statement
      result << approve_word(statement.result)
      unless statement.note.try(:empty?)
        result << ", #{t(:message_37, :scope => [:txt, :helper, :application])}: #{statement.note}"
        options[:class] = 'higher'
      end
      result = content_tag('div', statement.created_on.strftime('%d. %m. %Y'),
                           :class => 'info') + div_tag(result)
    end
    return content_tag('li', "#{div_tag(result, :class => 'long_info')} #{statement_type}", options)
  end
  
  # prints attestation link
  def attestation_link(study_plan)
    link_to(t(:message_38, :scope => [:txt, :helper, :application]), 
           {:controller => 'study_plans',
            :action => 'attest',
            :id => study_plan,
            :remote => true},
           {:id => "attestation_link", 
            :onclick => "$('attestation_link').innerHTML = '%s'" %
              t(:message_39, :scope => [:txt, :helper, :application])})
  end
  
  # prints approval link
  def approve_form(document, statement)
    statement.class.to_s =~ /(.*)Statement/
    person = $1.downcase
    if document.is_a?(StudyPlan) && document.approved? && 
      document.waits_for_actual_attestation?
      action = 'confirm_attest'
      title = t(:message_40, :scope => [:txt, :helper, :application]) + " " + t(person, :scope => [:txt, :helper, :application])
      options = [[t(:continue, :scope => [:txt, :helper, :application]), 1],
        [t(:continue_with_reproof, :scope => [:txt, :helper, :application]), 2],
        [t(:finish, :scope => [:txt, :helper, :application]), 0],
        [t(:interrupt, :scope => [:txt, :helper, :application]), 3]
      ]    
    else
      action = 'confirm_approve'
      title = t(:message_44, :scope => [:txt, :helper, :application]) + " " + t(person, :scope => [:txt, :helper, :application])
      options = [[t(:message_45, :scope => [:txt, :helper, :application]), 1], [t(:message_46, :scope => [:txt, :helper, :application]), 0]]
    end
    render(:partial => 'shared/approve_form', :locals => {:document => document,
      :title => title, :options => options, :action => action, :statement => 
      statement})
  end
  
  # prints methodology link
  def methodology_link(disert_theme)
    link_to(t(:message_47, :scope => [:txt, :helper, :application]),
            "pdf/methodology/%i.pdf" % disert_theme.id,
            {:id => "methodology_link#{disert_theme.id}"})
  end
  
  # prints attestation detail link
  def attestation_detail(study_plan)
    if @student
      link_to_remote(t(:message_48, :scope => [:txt, :helper, :application]),
                    {:url => {:controller => 'study_plans', 
                      :action => 'attestation_details', :id => study_plan}},
                    {:id => "detail_link#{study_plan.id}"})
    else
      attestation_links(study_plan)
    end
  end

  # prints link to annual report
  def annual_report(study_plan)
    link_to(t(:annual_report, :scope => [:txt, :helper, :application]),
            {:action => :annual_report, :controller => :study_plans,
           :id => study_plan.id}, :target => '_blank' )
  end
  
  def detail_links(user, index)
    if user.non_student?
      content = []
      content << link_to_function(t(:message_49, :scope => [:txt, :helper, :application]),
                                  back_to_list,
                                  :id => 'back_link')
      content << link_to_function(t(:message_50, :scope => [:txt, :helper, :application]), 
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

  # prints interrupt finish line
  def interrupt_finish_line(interrupt)
    finished_on = info_div(interrupt.finished_on.strftime('%d.%m.%Y'))
    content_tag('li', finished_on + t(:message_51, :scope => [:txt, :helper, :application]))
  end

  def prepare_scholarship_link
    link_to_unless_current(t(:message_52, :scope => [:txt, :helper, :application]), :controller => 'scholarships',
                          :action => 'index'){} 
  end

  def edit_link(object, name, meth = nil)
    label = object.send(name)
    label = label.send(meth) if label && meth
    cntr = object.class.to_s.underscore.pluralize
    link_to("#{changer_image(name)}#{label}",
           {:update => name,
           :after => loader_image("#{name}_changer"),
           :controller => cntr, 
           :action => "edit_#{name}",
           :id => object.id},
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
    link_to_remote(t(:message_53, :scope => [:txt, :helper, :application]), opts, :id => 'final_exam_link') if opts
  end

  def final_exam_terms_link
    link_to t(:message_0, :scope => [:txt, :helper, :terms]), :action => :list, :controller => :final_exam_terms, :future => 1
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
    link_to_remote(t(:message_54, :scope => [:txt, :helper, :application]), opts, :id => 'defense_link') if opts
  end

  def hide_link(element, text = t(:message_55, :scope => [:txt, :helper, :application]))
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

  def edit_cz_link(id, i, value)
    if @user.has_role?("faculty_secretary")
      link_to_remote(image_tag('change.png'),
                     :url => {:controller => 'study_plans',
                             :action => 'add_cz',
                             :id => id,
                             :final_area_id => i,
                             :final_area_value => value},
                     :update => 'final_area_cz'+i.to_s)
    end
  end

  def edit_en_link(id, i, value)
    if @user.has_role?("faculty_secretary")
      link_to_remote(image_tag('change.png'),
                     :url => {:controller => 'study_plans',
                             :action => 'add_en',
                             :id => id,
                             :final_area_id => i,
                             :final_area_value => value},
                     :update => 'final_area_en'+i.to_s)
    end
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

  def save_final_area_form(id, final_area_id,language, &proc)
    form_remote_tag(:url => {:controller => 'study_plans',
                            :action => 'save_'+language,
                            :id => id,
                            :final_area_id => final_area_id},
                    :update => 'final_area_'+ language + final_area_id.to_s,
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
      attribute_line(student, :display_name) + t(:message_56, :scope => [:txt, :helper, :application]) + ':'
    else
      long_info_helper(student.display_name, :class => 'printable') + 
        t(:message_57, :scope => [:txt, :helper, :application]) + ':'
    end
  end

  def remove_line
    link_to_function(image_tag('close.png'), "$('specialization_subject_form').remove()")
  end
  
  def student_tutor_line(index)
    if @user.has_role?('faculty_secretary')
      attribute_line(index, :tutor, :display_name) + t(:message_58, :scope => [:txt, :helper, :application]) + ':'
    else
      if index.tutor == nil
        long_info_helper(t(:message_59, :scope => [:txt, :helper, :application]), :class => 'printable') + 
          t(:message_60, :scope => [:txt, :helper, :application]) + ':'        
      else
        long_info_helper(index.tutor.display_name, :class => 'printable') + 
          t(:message_61, :scope => [:txt, :helper, :application]) + ':'
      end
    end
  end

  def literature_review_link(disert_theme)
    path = "/pdf/literature_review/%i.pdf" % disert_theme.id
    if File.exists?("#{Rail.root}/public/" + path)
      link_to t(:message_62, :scope => [:txt, :helper, :application]), path, :popup => true
    end
  end

  def self_report_link(disert_theme)
    path = "/pdf/self_report/%i.pdf" % disert_theme.id
    if File.exists?("#{Rails.root}/public/" + path)
      link_to t(:message_63, :scope => [:txt, :helper, :application]), path, :popup => true
    end
  end

  def disert_theme_link(disert_theme)
    path = "/pdf/disert_theme/%i.pdf" % disert_theme.id
      link_to t(:message_64, :scope => [:txt, :helper, :application]), path, :popup => true
    #end
  end

  def spinner_image(js_id = 'spinner')
    image_tag('loader.gif', :id => js_id, :style => 'display: none')
  end

  # TODO use on more places
  # returns select options for any labeled objects
  def label_options(objects, label_method = :label)
    options_for_select(objects.map{|o| [o.send(label_method), o.id]})
  end

  # returns select options for edit exam
  def label_options_edit(subjects,exam)
    options_from_collection_for_select(subjects, :id, :label, exam.subject_id)
  end

  # returns form for approving
  def approve_document_form(document, action, &proc)
    controller = document.class.to_s.underscore.pluralize
    form_tag({:controller => controller,
             :action => action,
             :id => document},
             {:remote => true},
            &proc)

  end
  
  def locale_link
    if I18n.locale != :cs
      link_to image_tag('cz.png', :style => 'margin: 5px 0px 7px 2px'), locale_url(:lang => 'cs')
    else
      link_to image_tag('gb.png'), locale_url(:lang => 'en')
    end
  end

  # translates approver 
  def translate_approver(approver)
    if approver.nil?
      I18n::t(:nobody, :scope => [:txt, :helper, :application])
    else
      I18n::t(approver.to_s.downcase, :scope => [:txt, :helper, :application])
    end
  end

  private
  def loader_image(field)
    "Element.replace('#{field}', '#{image_tag('loader.gif', :size => '12x12')}')"
  end

  def changer_image(name)
    image_tag('change.png', :id => "#{name}_changer")
  end
end
