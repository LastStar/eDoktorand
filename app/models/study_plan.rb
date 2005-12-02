require 'approvable'
class StudyPlan < ActiveRecord::Base
  include Approvable
  belongs_to :index
  has_many :plan_subjects
  has_one :approvement, :class_name => 'StudyPlanApprovement', :foreign_key =>
    'document_id'
  has_one :atestation, :foreign_key => 'document_id', :order => 'created_on'
  acts_as_audited
  validates_presence_of :index
  serialize :final_areas, Hash
  # returns true if study plan is approved
  def approved?
    return true if approved_on
  end
  # returns if study plan is canceled 
  def canceled?
    return true if canceled_on
  end
  # returns true if study plan is admited
  def admited?
    return true unless admited_on.nil?
  end
  # TODO should be redone 
  #  returns true if study plan has been atested for last atestation
  def atested_for?(date)
    return true if last_atested_on && last_atested_on > date
  end
  # returns atestation detail for next atestation  
  def next_atestation_detail
    return AtestationDetail.find(:first, :conditions => ['study_plan_id = ? and
    atestation_term = ?', id,
    Atestation.next_for_faculty(index.student.faculty)])
  end
  # returns atestation detail for actual atestations
  def actual_atestation_detail
    at = Atestation.actual_for_faculty(index.student.faculty)
    return AtestationDetail.find(:first, :conditions => ['study_plan_id = ? and
    atestation_term = ?', id, at])
  end
  # returns count of atestation for study plan
  def atestation_count
    Atestation.count(['document_id = ?', id])
  end
  # return plan subjects for atestation
  def atestation_subjects
    PlanSubject.find(:all, :conditions => ['study_plan_id = ? and finishing_on
    >= ? and finishing_on <= ?', id, atestation_count * 2 - 2,
    atestation_count * 2])
  end
  # aproves study plan with statement from parameters 
  def approve_with(params)
    statement = \
    eval("#{params['type']}.create(params)") 
    eval("approvement.#{params['type'].underscore} =
    statement")
    if statement.is_a?(LeaderStatement) && !approvement.tutor_statement
      approvement.tutor_statement =
      TutorStatement.create(statement.attributes)
    end
    canceled_on = statement.cancel? ? Time.now : nil
    approved_on = Time.now if statement.is_a?(DeanStatement) &&
      !statement.cancel?
    save
  end
# returns status of study plan
  def status
    if canceled?
      _('SP canceled')
    elsif approved?
      _('SP approved')
    elsif admited?
      _('SP admited')
    end
  end
# returns subjects which are finished
  def finished_subjects
   PlanSubject.find(:all, :conditions =>  [ \
                    "study_plan_id = ? and finished_on is not null", id])
  end
# returns subjects which are not finished
  def unfinished_subjects
   PlanSubject.find(:all, :conditions =>  [ \
                    "study_plan_id = ? and finished_on is null", id])
  end
end
