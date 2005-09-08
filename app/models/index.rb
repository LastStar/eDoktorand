class Index < ActiveRecord::Base
  belongs_to :student, :foreign_key => 'student_id'
  belongs_to :tutor
  belongs_to :study
  has_one :study_plan, :conditions => 'admited_on IS NOT NULL', :order =>
  'created_on desc'
  has_one :disert_theme, :order => 'created_on desc'
  has_many :exams
  belongs_to :coridor
  belongs_to :department
  validates_presence_of :student
  validates_presence_of :tutor
  # returns leader of department for this student
  def leader
    self.department.leadership.leader
  end
  # returns dean of department for this student
  def dean
    self.department.faculty.deanship.dean
  end
  # returns if study plan is finished
  def finished?
    return true unless self.finished_on.nil?
  end
  # returns statement if this index waits for approvement from person
  def statement_for(person)
    if self.study_plan && !self.study_plan.approved?
      self.study_plan.approvement ||= StudyPlanApprovement.create
      if result = self.study_plan.approvement.prepare_statement(person)
        return result
      end
    elsif self.disert_theme && !self.disert_theme.approved? 
      self.disert_theme.approvement ||= DisertThemeApprovement.create 
      if result = self.disert_theme.approvement.prepare_statement(person)
        return result
      end
#   elsif AtestationTerm.actual?(self.student.faculty) &&
#       !self.study_plan.atested_for?(AtestationTerm.actual(self.student.faculty))
#     self.study_plan.atestation ||= Atestation.create
#     return self.study_plan.atestation.prepare_statement(person)
    end
  end
end
