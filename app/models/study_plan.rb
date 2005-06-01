class StudyPlan < ActiveRecord::Base
  belongs_to :index
  has_many :plan_subjects
  has_one :approvement, :foreign_key => 'document_id'
  validates_presence_of :index
  # returns if study plan is canceled
  def canceled?
    return true if self.canceled_on
  end
end
