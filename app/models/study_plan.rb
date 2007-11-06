require 'approvable'
class StudyPlan < ActiveRecord::Base
  include Approvable
  untranslate_all
  belongs_to :index
  has_many :plan_subjects, :order => 'finishing_on', :dependent => :delete_all
  has_one :approvement, :class_name => 'StudyPlanApprovement',
    :foreign_key => 'document_id'
  has_one :atestation, :foreign_key => 'document_id', :order => 'created_on'
  has_many :approvements
  acts_as_audited
  validates_presence_of :index
  serialize :final_areas, Hash

  before_create :set_actual

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
    last_atested_on && last_atested_on.to_date > date
  end

  def atested_actual?
    date = Atestation.actual_for_faculty(self.index.faculty)
    self.atested_for?(date)
  end

  # returns true if tudy plan waits for actuala atestation
  def waits_for_actual_atestation?
    !atested_for?(Atestation.actual_for_faculty(index.student.faculty)) 
  end

  # returns atestation detail for next atestation  
  def next_atestation_detail
    AtestationDetail.find_by_study_plan_id_and_atestation_term(id, 
      Atestation.next_for_faculty(index.student.faculty))
  end

  def next_atestation_detail_or_new
    next_atestation_detail || AtestationDetail.new_for(index.student)
  end
  # returns atestation detail for actual atestations
  def actual_atestation_detail
    AtestationDetail.find_by_study_plan_id_and_atestation_term(id, 
      Atestation.actual_for_faculty(index.student.faculty))
  end

  # returns count of atestation for study plan
  def atestation_count
    Atestation.count(['document_id = ?', id])
  end

  # return plan subjects for atestation
  def atestation_subjects
    sql = 'study_plan_id = ? and finishing_on >= ? and finishing_on <= ?'
    PlanSubject.find(:all, :conditions => [sql, id, semester - 3, semester - 1])
  end

  def finished_atestation_subjects
    atestation_subjects.select(&:finished?)
  end
 
  def atestation_subjects_ratio
    "#{atestation_subjects.size} / #{finished_atestation_subjects.size}"
  end

  # return semester of the study from index
  def semester
    index.semester
  end

  # aproves study plan with statement from parameters 
  def approve_with(params)
    statement = \
    eval("#{params[:type]}.create(params)") 
    self.approvement ||= StudyPlanApprovement.create
    self.approvement.update_attribute("#{params[:type].underscore}_id", statement.id)
    if statement.is_a?(LeaderStatement) && !approvement.tutor_statement
      approvement.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    if statement.cancel?
      cancel! 
    elsif statement.is_a?(DeanStatement)
      approve! 
    end
    save
  end

  # atests study plan with statement from parameters
  def atest_with(params)
    statement = \
    eval("#{params[:type]}.create(params)") 
    atestation.update_attribute("#{params[:type].underscore}_id", statement.id)
    if statement.is_a?(DeanStatement)
      if statement.cancel?
        index.update_attribute('finished_on', Time.now)
      else
        update_attribute('last_atested_on', Time.now)
      end
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
      _('FE passed')
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
  def unfinished_external_subjects
    PlanSubject.find_unfinished_external(self).map {|ps| ps.subject}
  end

  def all_subjects_finished?
    unfinished_subjects.empty?
  end

  private
  def set_actual
    if old_actual = StudyPlan.find_by_index_id_and_actual(self.index.id, 1)
      old_actual.update_attribute(:actual, 0)
    end
    self.actual = 1
  end
end
