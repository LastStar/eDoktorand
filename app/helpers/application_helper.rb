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
  # prints tutor statement
  def print_statement(message, statement)
    result = message + ': ' 
    result << approve_word(statement.result)
    unless statement.note.empty?
      result << ', ' + (_("with note: ") + statement.note)
    end
    return result
  end
  # returns approve word for statement result
  def approve_word(result)
    [ _("cancel"), _("approve")][result]
  end
  # prints approve links
  def approve_links(document, controller)
    if @person == document.index.tutor &&
      (!document.approvement || (document.approvement &&
      !document.approvement.tutor_statement))
      approve_link(document, controller)
    elsif @person.is_a?(Leader) &&
      @person == document.index.leader &&
      document.approvement && !document.approvement.leader_statement
      approve_link(document, controller) 
    elsif @person.is_a?(Dean) &&
      document.approvement && document.approvement.leader_statement && 
      !document.approvement.dean_statement
      approve_link(document, controller)
    end
  end
  # prints atestation links
  def atestation_links(study_plan)
    if AtestationTerm.actual?(@person.faculty) && study_plan.approved?
      if @person == study_plan.index.tutor &&
        (!study_plan.atestation || (study_plan.atestation &&
        !study_plan.atestation.tutor_statement))
        atestation_link(study_plan)
      elsif @person.is_a?(Leader) &&
        @person == study_plan.index.leader &&
        study_plan.atestation && !study_plan.atestation.leader_statement
        atestation_link(study_plan) 
      elsif @person.is_a?(Dean) &&
        study_plan.atestation && study_plan.atestation.leader_statement && 
        !study_plan.atestation.dean_statement
        atestation_link(study_plan)
      end
    end
  end
  # prints subjects link
  def subjects_link(study_plan)
    content_tag('li', link_to_remote(_("subjects"), {:url => {:action => 'subjects',
    :controller => 'study_plans', :id => study_plan}, :loading =>
    visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade,
    "loading"), :complete => evaluate_remote_response}), :id =>
    "subject_link#{study_plan.id}")
  end
  private 
  # prints atestation link
  def atestation_link(study_plan)
    element = "approve_link#{study_plan.id}"
    content_tag('li', link_to_remote(_("atest"), :url => {:controller =>
    'study_plans', :action => 'atest', :id => study_plan}, :loading => 
    visual_effect(:appear, 'loading'), :interactive => visual_effect(:fade,
    "loading"), :complete => evaluate_remote_response), :id => element)
  end
  # prints approvement link
  def approve_link(document, controller)
    element = "approve_link#{document.id}"
    content_tag('li', link_to_remote(_("approve"), :url => {:controller => controller, 
    :action => 'approve', :id => document}, :loading => visual_effect(:appear, 'loading'), 
    :interactive => visual_effect(:fade, "loading"), 
    :complete => evaluate_remote_response), :id => element)
  end
  # prints tutor links 
  def tutor_links(study_plan)
    if !study_plan.canceled?
      [approve_links(study_plan, 'study_plans'),
      atestation_links(study_plan)].join
    end
  end
end
