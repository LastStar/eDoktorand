module ApplicationHelper
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
    Person.find(:all).map {|p| [p.display_name, p.id]}
  end
  # get examinator ids
  # allows null
  def examinator_null_ids
    arr = [['---', '0']]
    arr.concat(Person.find(:all).map {|p| [p.display_name, p.id]})
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
end
