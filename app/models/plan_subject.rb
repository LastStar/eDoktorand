class PlanSubject < ActiveRecord::Base
  belongs_to :study_plan
  belongs_to :subject
  # returns true if plan subject has exam
  def finished?
    return true unless self.finished_on.nil?
  end
end
