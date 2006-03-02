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
  has_one :interupt, :order => 'created_on desc'
  has_many :interupts

  validates_presence_of :student
  validates_presence_of :tutor

  # returns semesteer of the study
  def semester
    time = Time.now - enrolled_on
    if interupt 
      time -= interrupted_time
    end
    time.div(6.month) + 1
  end

  # returns year of the study
  def year
    (semester / 2) + 1
  end

  # returns leader of department for this student
  def leader
    department.leadership.leader if department.leadership
  end

  # returns dean of department for this student
  def dean
    department.faculty.deanship.dean
  end

  # returns if study plan is finished
  def finished?
    return true unless finished_on.nil?
  end

  # returns true if interupt just admited
  def admited_interupt?
    return true if interupt && !interupted?
  end

  # returns if stduy plan is interupted
  def interupted?
    if interupted_on && interupted_on < Time.now
      return true 
    end
  end

  # returns statement if this index waits for approvement from person
  def statement_for(user)
    if admited_interupt?
      interupt.approvement ||= InteruptApprovement.create
      if interupt.approvement.prepares_statement?(user)
        return interupt.approvement.prepare_statement(user)
      end
    elsif study_plan 
      if !study_plan.approved?
        study_plan.approvement ||= StudyPlanApprovement.create
        if study_plan.approvement.prepares_statement?(user)
          return study_plan.approvement.prepare_statement(user)
        end
      elsif study_plan.waits_for_actual_atestation?
        study_plan.atestation ||= Atestation.create
        return study_plan.atestation.prepare_statement(user)
      end
    end
  end

  # returns statement if this index waits for approvement from person
  def waits_for_statement?(user)
    if admited_interupt?
      approvement = interupt.approvement ||= InteruptApprovement.create
    elsif study_plan && !study_plan.approved?
      approvement = study_plan.approvement ||= StudyPlanApprovement.create
    elsif study_plan && study_plan.approved? &&
      study_plan.waits_for_actual_atestation?
      approvement = study_plan.atestation ||= Atestation.create
    end
    approvement && approvement.prepares_statement?(user)
  end

  # returns all indexes for person
  # accepts Base.find options. Include and order for now
  def self.find_for(user, options ={})
    if user.has_one_of_roles?(['admin', 'vicerector'])
      if options[:only_tutor]
        conditions = ['indices.tutor_id = ?', user.person.id]
      elsif options[:faculty] && options[:faculty] != '0'
        faculty = options[:faculty].is_a?(Faculty) ? options[:faculty] : \
          Faculty.find(options[:faculty])
        # TODO fix 
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
    if options[:unfinished]
      conditions.first << ' AND indices.finished_on IS NULL'
    end
    find(:all, :conditions => conditions, :include => [:study_plan, :student,
      :disert_theme, :department, :study, :coridor, :interupt], :order => options[:order])
  end

  # finds only indices tutored by user
  def self.find_tutored_by(user, options={})
    options[:conditions] = [' AND indices.tutor_id = ?', user.person.id]
    options[:order] = 'people.lastname'
    find_for(user, options)
  end

  # returns all indexes which waits for approvement from persons 
  # only for tutors, leader a deans
  def self.find_waiting_for_statement(user, options = {})
    sql = <<-SQL
      AND (study_plans.approved_on IS NULL OR disert_themes.approved_on IS NULL \
      OR study_plans.last_atested_on IS NULL OR indices.interupted_on IS NULL OR \
      study_plans.last_atested_on < ?) AND (indices.finished_on IS NULL OR \
      indices.finished_on = '0000-00-00 00:00:00') 
    SQL
    options[:conditions] = [sql, 
      Atestation.actual_for_faculty(user.person.faculty)]
    options[:order] = 'students.lastname'
    options[:only_tutor] = true
    result = find_for(user, options)
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
    if options[:form] != 0
      conditions.first << ' AND indices.study_id = ?'
      conditions << options[:form]
    end
    indices = Index.find_for(options[:user], :conditions => conditions, 
                                  :include => [:study_plan, :student, :disert_theme, :department, :study,
                                    :coridor, :interupt], :faculty => options[:faculty], :order => options[:order])
    if options[:year] != 0 
      if options[:year] == 4
        indices.reject! {|i| i.year < 4}
      else
        indices.reject! {|i| i.year != options[:year]}
      end
    end
    if options[:study_status] && options[:study_status] != '0'
      case options[:study_status]
      when '1'
        indices.reject! {|i| i.status != _('studying')}
      when '2'
        indices.reject! {|i| i.status != _('finished')}
      when '3'
        indices.reject! {|i| i.status != _('interupted') }
      end
    end
    if options[:status] && options[:status] != '0'
      case options[:status]
      when '1'
        indices.reject! {|i| i.study_plan && i.study_plan.admited?}
      when '2'
        indices.reject! {|i| !i.study_plan || !i.study_plan.admited? || i.study_plan.approvement.tutor_statement}
      when '3'
        indices.reject! {|i| i.study_plan_approved_by != 'tutor'}
      when '4'
        indices.reject! {|i| i.study_plan_approved_by != 'leader'}
      when '5'
        indices.reject! {|i| i.study_plan_approved_by != 'dean'}
      end
    end
    return indices
  end

  # returns status of index
  def status
    if finished?
      _('finished')
    elsif interupted?
      _('interupted')
    elsif year > 3
      _('continue')
    else
      _('studying')
    end
  end

  # switches study form
  def switch_study
    if study_id == 1 
      update_attribute('study_id', 2)
    else
      update_attribute('study_id', 1)
    end
  end

  # returns who approved study plan
  def study_plan_approved_by
    if study_plan
      study_plan.approved_by
    end
  end

  # returns full account number
  def full_account_number
    if account_number_prefix
      "#{account_number_prefix}-#{account_number}"
    else
      "#{account_number}"
    end
  end

  # returns time study was interrupted for 
  def interrupted_time
    interupts.inject(0) {|sum, i| sum += i.current_duration} 
  end

  # interupts study with date
  def interrupt!(start_date)
    update_attribute('interupted_on', start_date)
  end

  def line_class
    finished? ? 'finished' : ''
  end
end
