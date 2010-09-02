require 'approvable'
class StudyPlan < ActiveRecord::Base
  include Approvable
  
  belongs_to :index
  has_many :plan_subjects, :order => 'finishing_on', :dependent => :delete_all
  has_one :approval, :class_name => 'StudyPlanApproval',
    :foreign_key => 'document_id'
  has_one :attestation, :foreign_key => 'document_id', :order => 'created_on'
  # Have to be tested: Should be removed
  # has_one :attestation_detail, :foreign_key => 'study_plan_id', :order => 'created_on'
  has_many :approvals
  acts_as_audited
  validates_presence_of :index
  serialize :final_areas, Hash

  before_create :set_actual

  # validates final areas non emptyness
  def validate_on_update
    if final_areas
      if final_areas['cz'].values.join('').strip == '' ||
        final_areas['en'].values.join('').strip == ''
        errors.add('final_areas', I18n.t(:message_0, :scope => [:txt, :model, :study_plan]))
      end
    end
  end
  # returns true if study plan is approved
  def approved?
    !approved_on.nil?
  end

  def approve!(time = Time.now)
    update_attribute(:approved_on, time)
  end

  # returns if study plan is canceled 
  def canceled?
    #if canceled_on && approved_on && canceled_on.to_time > approved_on.to_time
    if canceled_on != nil
      return true
    else
      return false
    end
  end

  def cancel!(time = Time.now)
    update_attribute(:canceled_on, time)
  end

  # returns true if study plan is admited
  def admited?
    return true unless admited_on.nil?
  end

  #  returns true if study plan has been attested for last attestation Should be
  #  removed
  def attested_for?(date)
    last_attested_on && last_attested_on > date.to_time
  end

  def attested_actual?
    date = Attestation.actual_for_faculty(self.index.faculty)
    self.attested_for?(date)
  end

  # returns true if tudy plan waits for actuala attestation
  def waits_for_actual_attestation?
    !index.final_exam_passed? && 
      !attested_for?(Attestation.actual_for_faculty(index.student.faculty)) 
  end

  # returns attestation detail for next attestation  
  def next_attestation_detail
    AttestationDetail.find_by_study_plan_id_and_attestation_term(id, 
      Attestation.next_for_faculty(index.student.faculty))
  end

  def next_attestation_detail_or_new
    next_attestation_detail || AttestationDetail.new_for(index.student)
  end
  # returns attestation detail for actual attestations
  def actual_attestation_detail
    AttestationDetail.find_by_study_plan_id_and_attestation_term(id, 
      Attestation.actual_for_faculty(index.student.faculty))
  end

  # returns count of attestation for study plan
  def attestation_count
    Attestation.count(['document_id = ?', id])
  end

  # return plan subjects for attestation
  def attestation_subjects
    beg_sem = semester - 3
    end_sem = semester - 1
    return @attestation_subjects ||= plan_subjects.select do |ps|
      (beg_sem..end_sem).include? ps.finishing_on
    end
  end

  def finished_attestation_subjects
    attestation_subjects.select(&:finished?)
  end
 
  def attestation_subjects_ratio
    "#{attestation_subjects.size} / #{finished_attestation_subjects.size}"
  end

  # return semester of the study from index
  def semester
    index.semester
  end

  # aproves study plan with statement from parameters 
  def approve_with(params)
    statement = \
    eval("#{params[:type]}.create(params)") 
    self.approval ||= StudyPlanApproval.create
    self.approval.update_attribute("#{params[:type].underscore}_id", statement.id)
    if statement.is_a?(LeaderStatement) && !approval.tutor_statement
      approval.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    if statement.cancel?
      cancel! 
    elsif statement.is_a?(DeanStatement)
      approve! 
    end
    save
  end

  # attests study plan with statement from parameters
  def attest_with(params)
    statement = \
    eval("#{params[:type]}.create(params)")
    attestation.update_attribute("#{params[:type].underscore}_id", statement.id)
    if statement.is_a?(DeanStatement)
      if statement.cancel?
        index.update_attribute('finished_on', Time.now)
      else
        update_attribute('last_attested_on', Time.now)
      end
    elsif statement.is_a?(LeaderStatement) && !attestation.tutor_statement
      attestation.tutor_statement =
        TutorStatement.create(statement.attributes)
    end
    save
  end

  # returns status of study plan
  def status
    if index.disert_theme
      @status ||= if index.disert_theme.defense_passed? || index.final_exam_passed?
        ''
      elsif all_subjects_finished?
        I18n::t(:message_0, :scope => [:txt, :model, :plan])
      elsif canceled?
        I18n::t(:message_1, :scope => [:txt, :model, :plan])
      elsif approved?
        I18n::t(:message_2, :scope => [:txt, :model, :plan])
      elsif admited?
        I18n::t(:message_3, :scope => [:txt, :model, :plan])
      end
    else
      I18n::t(:message_4, :scope => [:txt, :model, :plan])
    end
  end

  # return last approving person localized string
  def approved_by
    if approved?
      I18n::t(:message_5, :scope => [:txt, :model, :plan])
    elsif approval
      approval.approved_by
    end
  end

  def last_approver
    if approval
      approval.last_approver
    end
  end

  # returns subjects which are finished
  def finished_subjects
   return @finished_subjects ||= plan_subjects.select {|ps| ps.finished?}
  end

  # returns subjects which are not finished
  def unfinished_subjects(param = nil)
    @unfinished_subjects ||= plan_subjects - self.finished_subjects

    if param == :subjects 
     return @unfinished_subjects.map {|p| p.subject}
    else
     return @unfinished_subjects
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
