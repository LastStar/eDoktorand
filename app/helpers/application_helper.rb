module ApplicationHelper
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
  # get department ids
  def department_ids(faculty_id = nil)
    conditions = ["faculty_id = ?", faculty_id] if faculty_id
    Department.find(:all, :conditions => conditions).map { |a| [a.name , a.id] }
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
  def coridor_ids
    Coridor.find_all.map {|s| [s.name, s.id]}
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
  def examinator_ids
    Tutor.find(:all).map {|p| [p.display_name, p.id]}
  end
  # get examinator ids
  # allows null
  def examinator_null_ids
    arr = [['---', '0']]
    arr.concat(Tutor.find(:all).map {|p| [p.display_name, p.id]})
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
      [s.subject.label, s.subject_id]})
  end
  # returns approve word for statement result
  def approve_word(result)
    [ _("canceled"), _("approved")][result]
  end
  # prints approve links
  def approve_links(document, controller)
    if !study_plan.canceled?
      if @person == document.index.tutor &&
        (!document.approvement || (document.approvement &&
        !document.approvement.tutor_statement))
        approve_link(document, controller, 'tutor')
      elsif @person.is_a?(Leader) &&
        @person == document.index.leader &&
        document.approvement && !document.approvement.leader_statement
        approve_link(document, controller, 'leader') 
      elsif @person.is_a?(Dean) &&
        document.approvement && document.approvement.leader_statement && 
        !document.approvement.dean_statement
        approve_link(document, controller, 'dean')
      end
    end
  end
  # prints atestation links
  def atestation_links(study_plan)
    if AtestationTerm.actual?(@person.faculty) && study_plan.approved? &&
      study_plan.index.disert_theme.approved?
      if @person == study_plan.index.tutor &&
        (!study_plan.atestation || (study_plan.atestation &&
        !study_plan.atestation.tutor_statement))
        atestation_link(study_plan, 'tutor')
      elsif @person.is_a?(Leader) &&
        @person == study_plan.index.leader &&
        study_plan.atestation && !study_plan.atestation.leader_statement
        atestation_link(study_plan, 'leader') 
      elsif @person.is_a?(Dean) &&
        study_plan.atestation && study_plan.atestation.leader_statement && 
        !study_plan.atestation.dean_statement
        atestation_link(study_plan, 'dean')
      end
    end
  end
  # prints subjects link
  def subjects_link(study_plan)
    link_to_remote(_("subjects"), {:url => {:action => 'subjects',
    :controller => 'study_plans', :id => study_plan}, :loading =>
    visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade,
    "loading"), :complete => evaluate_remote_response}, {:id =>
    "subject_link#{study_plan.id}"})
  end
  # prints statements approvement 
  def print_statements(approvement)
    links = ''
    if approvement.tutor_statement
      links << print_statement(approvement.tutor_statement)
    end
    if approvement.leader_statement
      links << print_statement(approvement.leader_statement)
    end
    if approvement.dean_statement
      links << print_statement(approvement.dean_statement) 
    end
    return links
  end
  # prints atestaion subject line wihch depends on finishing of the subject
  def atestation_subject_line(plan_subject, atestation_term)
    content = ''
    if plan_subject.finished? && (plan_subject.finished_on <= atestation_term.opening_on)
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
  private 
  # prints statement
  def print_statement(statement)
    result = ''
    result << approve_word(statement.result)
    unless statement.note.empty?
      result << ", #{_('with note: ')} #{truncate(statement.note, 30)}"
    end
    result = content_tag('div', statement.created_on.strftime('%d. %m. %Y'),
    :class => 'info') + result
    return content_tag('li', "#{content_tag('div', result, :class => 'long_info')}
    #{_(statement.type.to_s.underscore.humanize)}", :class => 'second')
  end
  # prints atestation link
  def atestation_link(study_plan, person)
    element = "approve_link#{study_plan.id}"
    link_to_remote(_("atest like #{person}"), {:url => {:controller =>
    'study_plans', :action => 'atest', :id => study_plan}, :loading => 
    visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade,
    "loading"), :complete => evaluate_remote_response}, {:id =>
    element})
  end
  # prints approvement link
  def approve_link(document, controller, person)
    if document.kind_of?(StudyPlan)
      element = "approve_link#{document.id}"
    else
      element = "approve_link#{document.index.study_plan.id}"
    end
    link_to_remote(_("approve #{document.class.to_s.underscore.humanize.downcase}
    like #{person}"), {:url => {:controller => controller, :action => 'approve',
    :id => document}, :loading => visual_effect(:appear, 'loading'), 
    :interactive => visual_effect(:fade, "loading"), :complete => 
    evaluate_remote_response}, {:id => element})
  end
  # prints methodology link
  def methodology_link(disert_theme)
    content_tag('li', link_to_remote(_("methodology file (opens new window)"), 
    {:url => {:controller => 'disert_themes', :action => 'file_clicked', 
    :id => disert_theme}, :loading => visual_effect(:appear, 'loading'), 
    :interactive => visual_effect(:fade, "loading"), :complete => 
    evaluate_remote_response}), {:id => "methodology_link#{disert_theme.id}"})
  end
  # prints atestation detail link
  def atestation_detail_link(study_plan)
    link_to_remote(_("additional information"), {:url => {:controller => 
    'study_plans', :action => 'atestation_details', :id => study_plan}, 
    :loading => visual_effect(:appear, 'loading'), :interactive => 
    visual_effect(:fade, "loading"), :complete => evaluate_remote_response}, 
    {:id => "detail_link#{study_plan.id}"})
  end
end
