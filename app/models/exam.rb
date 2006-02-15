require 'terms_calculator'
class Exam < ActiveRecord::Base
  belongs_to :index
  belongs_to :subject
  belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
  belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
  belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
  validates_presence_of :index
  validates_presence_of :subject
  attr_accessor :plan_subject
  # returns true if result is pass
  def passed?
   return true if result == 1
  end

  # returns all exams for user
  # got option :with_plan_subject if needed
  # then you can add :this_year to filter only this year exams 
  def self.find_for(user, options = {})
    if user.has_role?('tutor') 
      sql = ['first_examinator_id = ?', user.person.id]
    else
      sub_ids = Subject.find_for(user).map {|s| s.id}
      sql = ["subject_id IN (?)", sub_ids]
    end
    sql.first << ' and result = 1'
    exams = find(:all, :conditions => sql, :include => [:index, :subject], 
      :order => 'subjects.label')
    if options[:with_plan_subjects]
      exams.delete_if {|e| !(e.plan_subject = PlanSubject.find_for_exam(e))}
      if options[:this_year]
        exams.delete_if {|e| e.plan_subject.finished_on < TermsCalculator.this_year_start}
      end
    end
    exams
  end
end
