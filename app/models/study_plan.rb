class StudyPlan < ActiveRecord::Base
  belongs_to :index
  has_many :plan_subjects
  has_one :approvement, :class_name => 'StudyPlanApprovement', :foreign_key =>
  'document_id'
  has_one :atestation, :foreign_key => 'document_id', :order => 'created_on'
  validates_presence_of :index
  # returns true if study plan is approved
  def approved?
    return true if self.approved_on
  end
  # returns if study plan is canceled
  def canceled?
    return true if self.canceled_on
  end
  # returns true if study plan is admited
  def admited?
    return true unless self.admited_on.nil?
  end
  #  returns true if study plan has been atested for last atestation
  def atested_for?(atestation)
    return true if self.last_atested_on && self.last_atested_on > atestation.opening_on
  end
end
