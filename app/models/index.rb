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
  has_many :interupts
  validates_presence_of :student
  validates_presence_of :tutor
  def year
    (Time.now - enrolled_on).div(1.year) + 1
  end
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
  def statement_for(user)
    if self.study_plan && !self.study_plan.approved?
      self.study_plan.approvement ||= StudyPlanApprovement.create
      if result = self.study_plan.approvement.prepare_statement(user)
        return result
      end
    elsif self.disert_theme && self.disert_theme.has_methodology? && !self.disert_theme.approved? 
      self.disert_theme.approvement ||= DisertThemeApprovement.create 
      if result = self.disert_theme.approvement.prepare_statement(user)
        return result
      end
    elsif self.disert_theme.approved? && Atestation.actual_for_faculty(self.student.faculty) &&
    !self.study_plan.atested_for?(Atestation.actual_for_faculty(self.student.faculty))
      self.study_plan.atestation ||= Atestation.create
      return self.study_plan.atestation.prepare_statement(user)
    end
  end
  # returns statement if this index waits for approvement from person
  def waits_for_statement?(user)
    if self.study_plan && !self.study_plan.approved?
      self.study_plan.approvement ||= StudyPlanApprovement.create
      if self.study_plan.approvement.prepares_statement?(user)
        return true
      end
    elsif self.disert_theme && self.disert_theme.has_methodology? && !self.disert_theme.approved? 
      self.disert_theme.approvement ||= DisertThemeApprovement.create 
      if self.disert_theme.approvement.prepares_statement?(user)
        return true
      end
    elsif self.study_plan && self.study_plan.approved? &&
    !self.study_plan.atested_for?(Atestation.actual_for_faculty(user.person.faculty))
      if self.study_plan.atestation.prepares_statement?(user)
        return true
      end
    end
  end
  # returns all indexes for person
  # accepts Base.find options. Include and order for now
  def self.find_for_user(user, options ={})
    if user.has_one_of_roles?(['admin', 'vicerector'])
      conditions  = ['NULL IS NULL']
    elsif user.has_one_of_roles?(['dean', 'faculty_secretary'])
      conditions = ["department_id IN (" +  user.person.faculty.departments.map {|dep|
      dep.id}.join(', ') + ")"]
    elsif user.has_one_of_roles?(['leader', 'department_secretary'])
      conditions = ['department_id = ?', user.person.leadership.department_id]
    elsif user.has_role?('tutor')
      conditions = ['tutor_id = ?', user.person.id]
    else
      conditions = ["NULL IS NOT NULL"]
    end
    if options[:conditions]
      conditions.first << options[:conditions].first 
      conditions.concat(options[:conditions][1..-1])
    end
    self.find(:all, :conditions => conditions, :include => options[:include],
    :order => options[:order])
  end
  # returns all indexes which waits for approvement from persons 
  # only for tutors, leader a deans
  def self.find_waiting_for_statement(user, options = {})
    result = self.find_for_user(user, :conditions => [' AND (study_plans.approved_on IS NULL OR
    disert_themes.approved_on IS NULL OR study_plans.last_atested_on IS NULL OR
    study_plans.last_atested_on < ?)', Atestation.actual_for_faculty(user.person.faculty)],
    :include => [:study_plan, :disert_theme])
    if user.has_one_of_roles?(['tutor', 'leader', 'dean'])
      result.select {|i| i.waits_for_statement?(user)} 
    else
      result
    end
  end
  # search on selected criteria
  def self.find_by_criteria(options = {})
    conditions = ['NULL IS NULL']
    if options[:year] != 0
      conditions.first << ' AND indices.created_on > ? AND indices.created_on
      < ?'
      conditions << Time.mktime(Time.now.year - options[:year], 10, 1)
      conditions << Time.mktime(Time.now.year - (options[:year] - 1), 10, 1)
    end
    if options[:department] != 0
      conditions.first << ' AND indices.department_id = ?'
      conditions << options[:department]
    elsif options[:coridor] != 0
      conditions.first << ' AND indices.coridor_id = ?'
      conditions << options[:coridor]
    end
    Index.find(:all, :conditions => conditions)
  end
end
