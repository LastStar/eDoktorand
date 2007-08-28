require 'terms_calculator'
class Exam < ActiveRecord::Base
  untranslate_all

  belongs_to :index
  belongs_to :subject
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
  belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
  belongs_to :third_examinator, :class_name => "Person", :foreign_key => "third_examinator_id"
  belongs_to :fourth_examinator, :class_name => "Person", :foreign_key => "fourth_examinator_id"

  validates_presence_of :index
  validates_presence_of :subject

  after_create :finish_plan_subject

  attr_accessor :plan_subject

  N_('Creating external exam for student')
  N_('Exam for student')
 
  # returns true if result is pass
  def passed?
   return true if result == 1
  end

  # returns all exams for user
  # got option :with_plan_subject if needed
  # then you can add :this_year to filter only this year exams 
  def self.find_for(user, options = {})
    if user.has_one_of_roles?(['tutor','examinator']) 
      sql = ['first_examinator_id = ?', user.person.id]
    else
      sub_ids = Subject.find_for(user).map {|s| s.id}
      sql = ["subject_id IN (?)", sub_ids]
    end
    sql.first << ' and result = 1'
    if options[:this_year]
      sql.first << ' and passed_on > ?'
      sql << TermsCalculator.this_year_start
    end
    find(:all, :conditions => sql, :include => [{:index => :student}, :subject], 
      :order => 'subjects.label')
    # remove exams that don't have plan subject
    # exams.delete_if {|e| !(e.plan_subject = PlanSubject.find_for_exam(e))}
  end

  def self.from_probation_term(probation_term, student = nil)
    exam = new
    exam.index = student.index if student
    exam.subject_id = probation_term.subject.id
    exam.first_examinator_id = probation_term.first_examinator_id
    exam.second_examinator_id = probation_term.second_examinator_id
    return exam
  end

  private
  def finish_plan_subject
    PlanSubject.find_for_exam(self).finish!(passed_on) if passed?
  end
end
