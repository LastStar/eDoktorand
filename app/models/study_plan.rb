class StudyPlan < ActiveRecord::Base
  belongs_to :index
  has_many :plan_subjects
  has_one :approvement, :foreign_key => 'document_id'
  validates_presence_of :index
  # returns if study plan is approved
  def approved?
    return true if self.approved_on
  end
  # returns if study plan is canceled
  def canceled?
    return true if self.canceled_on
  end
  # returns if study plan is admited
  def admited?
    return true unless self.admited_on.nil?
  end

end
