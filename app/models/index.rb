class Index < ActiveRecord::Base
  belongs_to :student, :foreign_key => 'student_id'
  belongs_to :tutor
  belongs_to :study
  has_one :study_plan, :conditions => 'admited_on IS NOT NULL', :order =>
  'created_on desc'
  has_one :disert_theme
  has_many :exams
  belongs_to :coridor
  belongs_to :department
  validates_presence_of :student
  validates_presence_of :tutor
  # returns leader of department for this student
  def leader
    self.department.leadership.leader
  end
  # returns if study plan is finished
  def finished?
    return true unless self.finished_on.nil?
  end

end
