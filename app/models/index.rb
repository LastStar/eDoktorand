class Index < ActiveRecord::Base
  include Approvable

  belongs_to :student, :foreign_key => 'student_id'
  belongs_to :tutor
  belongs_to :study
  has_one :study_plan, :conditions => 'admited_on IS NOT NULL', :order =>
  'created_on desc'
  has_one :disert_theme, :order => 'created_on desc'
  has_one :final_exam_term
  has_many :exams
  belongs_to :coridor
  belongs_to :department
  has_many :interupts, :order => 'created_on desc'
  has_many :extra_scholarships, :order => 'created_on desc'
  has_many :regular_scholarships, :order => 'created_on desc'
  has_one :approvement, :class_name => 'FinalExamApprovement',
    :foreign_key => 'document_id'

  validates_presence_of :student
  validates_presence_of :tutor

  # returns semesteer of the study
  def semester
    time = Time.now - enrolled_on
    if self.interupt 
      time -= interrupted_time
    end
    time.div(6.month) + 1
  end

  # returns year of the study
  def year
    ((semester - 1) / 2) + 1
  end

  # returns leader of department for this student
  def leader
    department.leader
  end

  # returns dean of department for this student
  def dean
    department.faculty.dean
  end

  # returns if study plan is finished
  def finished?
    !finished_on.nil?
  end

  # returns true if interupt just admited
  def admited_interupt?
    interupt && !interupted? && !interupt.finished?
  end

  # returns if stduy plan is interupted
  def interupted?
    interupted_on && interupted_on < Time.now && !interupt.finished?
  end

  # returns true if studen claimed for final exam
  def claimed_for_final_exam?
    claimed_final_application? && approved?
  end

  # returns statement if this index waits for approvement from person
  def statement_for(user)
    if claimed_final_application?
      self.approvement ||= FinalExamApprovement.create
      if approvement.prepares_statement?(user)
        return approvement.prepare_statement(user)
      end
    elsif admited_interupt?
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
    if claimed_final_application?
      temp_approvement = self.approvement ||= FinalExamApprovement.create
    elsif admited_interupt?
      temp_approvement = interupt.approvement ||= InteruptApprovement.create
    elsif study_plan && !study_plan.approved?
      temp_approvement = study_plan.approvement ||= StudyPlanApprovement.create
    elsif study_plan && study_plan.approved? &&
      study_plan.waits_for_actual_atestation?
      temp_approvement = study_plan.atestation ||= Atestation.create
    end
    temp_approvement && temp_approvement.prepares_statement?(user)
  end

  # returns last interrupt
  def interupt
    @interupt ||= case interupts.size
    when 0
      nil
    when 1
      interupts.first
    else
      interupts.max {|x,y| x.created_on <=> y.created_on}
    end
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
    if options[:not_interupted]
      conditions.first << ' AND indices.interupted_on IS NULL'
    end
    find(:all, :conditions => conditions, 
         :include => [:study_plan, :student, :disert_theme, :department,
                      :study, :coridor, :interupts, :extra_scholarships, 
                      :regular_scholarships],
         :order => options[:order])
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
    options[:order] = 'people.lastname'
    options[:only_tutor] = true
    options[:unfinished] = true
    result = find_for(user, options)
    if user.has_role?('faculty_secretary')
      result.select do |i|
        i.waits_for_scholarship_confirmation? ||
        i.interupt_waits_for_confirmation? ||
        i.not_even_admited_interupt? ||
        i.waits_for_statement?(user) 
      end
    elsif user.has_one_of_roles?(['tutor', 'leader', 'dean'])
      result.select {|i| i.waits_for_statement?(user)} 
    end
  end

  # search on selected criteria
  def self.find_by_criteria(options = {})
    conditions = ['']
    if options[:department] && options[:department] != 0
      conditions.first << ' AND indices.department_id = ?'
      conditions << options[:department]
    elsif options[:coridor] && options[:coridor] != 0
      conditions.first << ' AND indices.coridor_id = ?'
      conditions << options[:coridor]
    end
    if options[:form] && options[:form] != 0
      conditions.first << ' AND indices.study_id = ?'
      conditions << options[:form]
    end
    if options[:study_status] && options[:study_status] != '0'
      case options[:study_status].to_i
      when 1
        conditions.first << ' AND indices.finished_on IS NULL' +
                            ' AND indices.interupted_on IS NULL'
      when 2
        conditions.first << ' AND indices.finished_on IS NOT NULL' 
      when 3
        conditions.first << ' AND indices.interupted_on IS NOT NULL' 
      when 4
        conditions.first << ' AND NULL IS NOT NULL'
      end
    end
    indices = Index.find_for(options[:user], :conditions => conditions, 
                            :faculty => options[:faculty], 
                            :order => options[:order])
    if options[:year] != 0 
      if options[:year] == 4
        indices.reject! {|i| i.year < 4}
      else
        indices.reject! {|i| i.year != options[:year]}
      end
    end
    if options[:status] && options[:status] != '0'
      case options[:status]
      when '1'
        indices.reject! {|i| i.study_plan && i.study_plan.admited?}
      when '2'
        indices.reject! {|i| !i.study_plan || !i.study_plan.admited? || 
                            i.study_plan.approvement ||
                            i.study_plan.approvement.tutor_statement}
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

  def self.find_studying_for(user, options = {})
    opts = {:unfinished => true, :not_interupted => true} 
    opts[:order] = options[:order] || 'people.lastname'
    find_for(user, opts)
  end

  def self.find_studying_on_department(department)
    find(:all, :conditions => ['department_id = ? and finished_on is null',
                              department.id])

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
  # TODO add history and use date
  def switch_study!(date = Date.today)
    if study_id == 1 
      update_attribute('study_id', 2)
    else
      update_attribute('study_id', 1)
    end
  end

  # finishes study
  def finish!(date = Date.today)
    update_attribute('finished_on', date)
  end

  # unfinishes study 
  def unfinish!
    update_attribute('finished_on', nil)
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

  # interupts study with date
  def end_interupt!(end_date)
    update_attribute('interupted_on', nil)
    if end_date.is_a? Hash
      end_date = Time.local(end_date['year'].to_i,
                           end_date['month'].to_i).end_of_month
    end
    interupt.update_attribute('finished_on', end_date)
  end

  def line_class
    finished? ? 'finished' : ''
  end

  def not_even_admited_interupt?
    !interupted? && !admited_interupt?
  end

  def interupt_waits_for_confirmation?
    admited_interupt? && interupt.approved? && !interupt.finished? &&
      !interupted_on 
  end

  def close_to_interupt_end_or_after?(months = 3)
    interupt && !interupt.finished? && Time.today > (interupt.end_on - months.month)
  end

  def waits_for_scholarship_confirmation?
    student.scholarship_claimed_at && !student.scholarship_supervised_at
  end

  # TODO stub method
  def current_extra_scholarship
    unless @current_extra_scholarship || extra_scholarships.empty?
        @current_extra_scholarship = extra_scholarships.first
    else
      @current_extra_scholarship
    end
  end

  def current_extra_scholarship_sum
    ExtraScholarship.find_all_unpayed_by_index(self.id).inject(0) do |sum, s|
      sum += s.amount
    end
  end

  # TODO stub method
  def current_regular_scholarship
    if !@current_regular_scholarship && !regular_scholarships.empty?
        @current_regular_scholarship = regular_scholarships.first
    else
      @current_regular_scholarship = 
        regular_scholarships.build('amount' => ScholarshipCalculator.for(self),
                                   'index_id' => self.id)
    end
  end

  def faculty
    department.faculty
  end

  def present_study?
    study.id == 1
  end

  def claim_final_application!
    update_attribute(:final_application_claimed_at, Time.now)
  end

  def claimed_final_application?
    !final_application_claimed_at.nil?
  end

  # for approvement purposes
  def index
    self
  end
end
