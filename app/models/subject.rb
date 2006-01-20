class Subject < ActiveRecord::Base
  has_many :coridors_subjects
  has_many :plan_subjects
  has_many :exams
  has_many :probation_terms
  has_and_belongs_to_many :departments
  validates_presence_of :label

# returns subjects for user
  def self.for_person(person)
    if (person.is_a? Dean) ||
      (person.is_a? FacultySecretary)
      faculty = person.department.faculty 
      @subjects = []
      faculty.departments.each {|dep| @subjects << dep.subjects}
    elsif (person.is_a? Leader) ||
      (person.is_a? DepartmentSecretary) ||
      (person.is_a? Tutor)
      @subjects = person.tutorship.department.subjects
    elsif (person.is_a? Student)
      @plan_subjects = person.index.study_plan.plan_subjects
      @plan_subjects.each{|plan| @subjects << plan.subject}
    else 
      @subjects = Subject.find_all()
    end
    return @subjects
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

end
