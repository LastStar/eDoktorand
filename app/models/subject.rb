class Subject < ActiveRecord::Base
  untranslate_all
  has_many :coridor_subjects
  has_many :plan_subjects
  has_many :exams
  has_many :probation_terms
  has_many :future_probation_terms, :class_name => "ProbationTerm",
           :conditions => ["date > ?", Date.today]
  has_and_belongs_to_many :departments

  validates_presence_of :label, :message => N_("label can't be empty")

  # returns all subjects for user
  def self.find_for(user, option = nil)
    if user.has_one_of_roles?(['tutor', 'leader', 'department_secretary', 'examinator'])
      subjects = user.person.department.subjects
    elsif user.has_one_of_roles?(['dean', 'faculty_secretary']) 
      subjects = user.person.faculty.departments.map {|dep| dep.subjects}.flatten
    elsif user.has_role?('student')
      subjects = user.person.index.study_plan.plan_subjects.map {|ps| ps.subject}
    end
    if option == :not_finished
      subjects.select do |sub|
        sub.plan_subjects.detect do |ps|
          ps.study_plan.approved? && !ps.finished?  
        end
      end
    else
      subjects
    end
  end

  # returns subjects for faculty
  def self.for_faculty_select(faculty)
    faculty = Faculty.find(faculty) unless faculty.is_a?(Faculty)
    faculty.departments.inject([]) {|arr, d| arr << d.subjects}.flatten.map \
      {|sub| [sub.label.to(40), sub.id]}
  end

  # returns options for html select
  def self.language_for_select
    self.find(:all).map {|sub| [sub.label, sub.id]}
  end

  def select_label
    chars = label.split(//)
    trunc = chars.length > 40 ? chars[0...37].join + '...' : label
     if code != nil
       "#{code} - #{trunc}"
     else
       "#{trunc}"
     end
  end

  def self.find_for_coridor(coridor, options = {})
    # TODO pure sql
    taken = CoridorSubject.find(:all, 
                                :conditions => ['coridor_id = ?', coridor])
    taken.map!(&:subject_id)

    if options[:not_taken]
      Subject.find(:all, :conditions => ['id not in(?) and type is null',
                                         taken],
                   :order => 'label')
    else
      Subject.find(taken, :order => 'label')
    end

  end
end
