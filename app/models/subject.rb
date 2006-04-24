class Subject < ActiveRecord::Base
  has_many :coridors_subjects
  has_many :plan_subjects
  has_many :exams
  has_many :probation_terms
  has_many :future_probation_terms, :class_name => "ProbationTerm", :conditions => ["date > ?", Date.today]
  has_and_belongs_to_many :departments
  validates_presence_of :label
  has_and_belongs_to_many :departments

  # returns all subjects for user
  def self.find_for(user)
    if user.has_one_of_roles?(['leader', 'department_secretary'])
      user.person.department.subjects
    elsif user.has_one_of_roles?(['dean', 'faculty_secretary']) 
      user.person.faculty.departments.map {|dep| dep.subjects}.flatten
    elsif user.has_role?('student')
      user.person.index.study_plan.plan_subjects.map {|ps| ps.subject}
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
    "#{code} - #{label}"
  end

end
