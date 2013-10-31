class Subject < ActiveRecord::Base

  has_many :specialization_subjects
  has_many :plan_subjects
  has_many :exams
  has_many :probation_terms
  has_many :future_probation_terms, :class_name => "ProbationTerm",
           :conditions => ["date > ?", Date.today]
  has_and_belongs_to_many :departments

  validates_presence_of :label, :message => I18n::t(:label_must_be_present, :scope => [:model, :subject])

  # returns all subjects for user
  # mus be redone in some lighter fashion
  def self.find_for(user, option = nil)
    if user.has_role?('vicerector')
      faculties = Faculty.find(:all)
      subjects = []
      for faculty in faculties
        subjects.concat(faculty.departments.map {|dep| dep.subjects}.flatten)
      end
    elsif user.has_one_of_roles?(['tutor', 'leader', 'department_secretary', 'examinator'])
      subjects = user.person.department.subjects
    elsif user.has_one_of_roles?(['dean', 'faculty_secretary'])
      subjects = user.person.faculty.departments.map {|dep| dep.subjects}.flatten
    elsif user.has_role?('student')
      subjects = user.person.index.study_plan.plan_subjects.map {|ps| ps.subject}
    end
    if option == :not_finished
      subjects = subjects.select do |sub|
        sub.plan_subjects.detect do |ps|
          ps.study_plan.approved? && !ps.finished?
        end
      end
    end
    return subjects.uniq.sort {|x, y| x.label <=> y.label}
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

  def select_label(locale = 'cs')
    logger.debug locale == :cs
    lbl = if locale != :cs && label_en
            label_en
          else
            label
          end.split(//)
    lbl = lbl.length > 40 ? lbl[0...37].join + '...' : lbl.join
     if code.present?
       "#{code} - #{lbl}"
     else
       "#{lbl}"
     end
  end

  def self.find_for_specialization(specialization, options = {})
    taken = SpecializationSubject.all(:select => 'subject_id',
                                      :conditions => ['specialization_id = ?',
                                        specialization]).map(&:subject_id)
    if options[:not_taken]
      all(:conditions => ['id not in(?) and type is null', taken],
          :order => 'label')
    else
      Subject.find(taken, :order => 'label')
    end

  end
end
