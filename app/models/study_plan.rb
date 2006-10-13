require 'approvable'
class StudyPlan < ActiveRecord::Base
  include Approvable
  belongs_to :index
  has_many :plan_subjects, :order => 'finishing_on'
  has_one :approvement, :class_name => 'StudyPlanApprovement',
    :foreign_key => 'document_id'
  has_one :atestation, :foreign_key => 'document_id', :order => 'created_on'
  acts_as_audited
  validates_presence_of :index
  serialize :final_areas, Hash

  # returns true if study plan is approved
  def approved?
    !approved_on.nil?
  end

  def approve!(time = Time.now)
    update_attribute(:approved_on, time)
  end

  # returns if study plan is canceled 
  def canceled?
    return true if canceled_on
  end

  def cancel!(time = Time.now)
    update_attribute(:canceled_on, time)
  end

  # returns true if study plan is admited
  def admited?
    return true unless admited_on.nil?
  end

  #  returns true if study plan has been atested for last atestation
  def atested_for?(date)
    last_atested_on && last_atested_on > date
  end

  # returns true if tudy plan waits for actuala atestation
  def waits_for_actual_atestation?
    !atested_for?(Atestation.actual_for_faculty(index.student.faculty)) 
  end

  # returns atestation detail for next atestation  
  def next_atestation_detail
    return AtestationDetail.find(:first, :conditions => ['study_plan_id = ? and
      atestation_term = ?', id, Atestation.next_for_faculty(index.student.faculty)])
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
    >= ? and finishing_on <= ?', id, semester - 2,
    semester])
  end

  # return semester of the study from index
  def semester
    index.semester
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
    cancel! if statement.cancel?
    approve! if statement.is_a?(DeanStatement) && !statement.cancel?
    save
  end

  # atests study plan with statement from parameters
  def atest_with(params)
    statement = \
    eval("#{params['type']}.create(params)") 
    eval("atestation.#{params['type'].underscore} =
      statement")
    if statement.cancel? && statement.is_a?(DeanStatement)
      index.update_attribute('finished_on', Time.now)
    elsif statement.is_a?(LeaderStatement) && !atestation.tutor_statement
      atestation.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    save
  end

  # returns status of study plan
  def status
    if index.disert_theme.defense_passed?
      ''
    elsif index.final_exam_passed?
      _('FE_passed')
    elsif all_subjects_finished?
      _('all_finished')
    elsif canceled?
      _('SP canceled')
    elsif approved?
      _('SP approved')
    elsif admited?
      _('SP admited')
    end
  end

  # return last approving person localized string
  def approved_by
    if approved?
      _('dean')
    elsif approvement
      approvement.approved_by
    end
  end

  def last_approver
    if approvement
      approvement.last_approver
    end
  end

  # returns subjects which are finished
  def finished_subjects
   PlanSubject.find(:all, :conditions =>  [ \
                    "study_plan_id = ? and finished_on is not null", id])
  end

  # returns subjects which are not finished
  def unfinished_subjects(param = nil)
    options = {:conditions => ["study_plan_id = ? and finished_on is null", id]}
    options[:include] = :subject if param == :subjects
    ps = PlanSubject.find(:all, options)
    if param == :subjects 
     ps.map {|p| p.subject}
    else
     ps
    end
  end

  # returns all external subject for student
  def external_subjects
    PlanSubject.find_unfinished_external(:study_plan => self).map {|ps| ps.subject}
  end

  def all_subjects_finished?
    unfinished_subjects.empty?
  end

end
