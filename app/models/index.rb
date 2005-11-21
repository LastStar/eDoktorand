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
    self.department.leadership.leader if self.department.leadership
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
      if (self.study_plan.atestation) && (self.study_plan.atestation.prepares_statement?(user))
        return true
      end
    end
  end
  # returns all indexes for person
  # accepts Base.find options. Include and order for now
  def self.find_for_user(user, options ={})
    if user.has_one_of_roles?(['admin', 'vicerector'])
      if options[:faculty] && options[:faculty] != '0'
       faculty = options[:faculty].is_a?(Faculty) ? options[:faculty] : \
         Faculty.find(options[:faculty])
         conditions = ["indices.department_id IN (#{faculty.departments_for_sql})"]
      else
        conditions  = ['NULL IS NULL']
      end
    elsif user.has_one_of_roles?(['dean', 'faculty_secretary'])
      conditions = ["indices.department_id IN (#{user.person.faculty.departments_for_sql})"]
    elsif user.has_one_of_roles?(['leader', 'department_secretary'])
      conditions = ['indices.department_id = ?', user.person.department.id]
    elsif user.has_role?('tutor')
      conditions = ['indices.tutor_id = ?', user.person.id]
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
  def self.find_waiting_for_statement(user)
    condition_sql = <<-SQL
      AND (study_plans.approved_on IS NULL OR disert_themes.approved_on IS NULL \
      OR study_plans.last_atested_on IS NULL OR \
      study_plans.last_atested_on < ?) AND (indices.finished_on IS NULL OR \
      indices.finished_on = '0000-00-00 00:00:00') 
      SQL
    result = self.find_for_user(user, :conditions => [condition_sql, Atestation.actual_for_faculty(user.person.faculty)],
      :include => [:student, :study_plan, :disert_theme, :department, :study, :coridor])
    if user.has_one_of_roles?(['tutor', 'leader', 'dean'])
      result.select {|i| i.waits_for_statement?(user)} 
    else
      result
    end
  end
  # search on selected criteria
  def self.find_by_criteria(options = {})
    conditions = ['']
    if options[:department] != 0
      conditions.first << ' AND indices.department_id = ?'
      conditions << options[:department]
    elsif options[:coridor] != 0
      conditions.first << ' AND indices.coridor_id = ?'
      conditions << options[:coridor]
    end
    indices = Index.find_for_user(options[:user], :conditions => conditions, 
      :include => [:study_plan, :student, :disert_theme, :department, :study,
      :coridor], :faculty => options[:faculty], :order => options[:order])
    if options[:year] != 0
      indices.reject! {|i| i.year != options[:year]}
    end
    if options[:status] && options[:status] != '0'
      case options[:status]
      when '1'
        indices.reject! {|i| i.study_plan && i.study_plan.admited?}
      when '2'
        indices.reject! {|i| !i.study_plan || !i.study_plan.admited? || i.study_plan.approvement.tutor_statement}
      when '3'
        indices.reject! {|i| !i.study_plan || i.study_plan.approvement.leader_statement || !i.study_plan.approvement.tutor_statement}
      when '4'
        indices.reject! {|i| !i.study_plan || i.study_plan.approvement.dean_statement || !i.study_plan.approvement.leader_statement}
      when '4'
        indices.reject! {|i| !i.study_plan || !i.study_plan.approvement.dean_statement && i.study_plan.approvement.leader_statement}
      end
    end
      return indices
  end
# returns status of index
  def status
    if self.finished?
      _('ST finished')
    else
      _('ST running')
    end
  end
end
