# FIXME move to its own class with metaclass
class String
  def sql_and(chunk)
    if self.empty?
      self << chunk
    elsif !chunk.strip.empty?
      self << ' and ' << chunk
    end
  end
end

class Index < ActiveRecord::Base
  include Approvable

  
  
  PREFIX_WEIGHTS = [1, 2, 4, 8, 5, 10]
  ACCOUNT_WEIGHTS = [1, 2, 4, 8, 5, 10, 9, 7, 3, 6]
  NOT_FINISHED_COND = <<-SQL
    (indices.finished_on is null or indices.finished_on > ?)\
    and disert_themes.defense_passed_on is null
  SQL
  DEPARTMENTS_COND = "indices.department_id in (?)"
  TUTOR_COND = "indices.tutor_id = ?"
  NOT_INTERUPTED_COND = <<-SQL
    (indices.interupted_on is null or indices.interupted_on > ?)
  SQL
  ENROLLED_COND = "indices.enrolled_on < ?"
  NOT_ABSOLVED_COND = <<-SQL
    (disert_themes.defense_passed_on is null\
    or disert_themes.defense_passed_on > ?)
  SQL
  LASTNAME_COND = "people.lastname like ?"
  PRESENT_COND = "indices.study_id = 1"
  FINISHED_COND = <<-SQL
    indices.finished_on is not null and indices.finished_on < ?
  SQL
  INTERUPTED_COND = "indices.interupted_on is not null"
  ABSOLVED_COND = "disert_themes.defense_passed_on is not null"
  PASSED_FINAL_COND = "indices.final_exam_passed_on is not null"
  CORRIDOR_COND = "indices.coridor_id = ?"
  STUDY_COND = " indices.study_id = ?"


  belongs_to :student, :foreign_key => 'student_id'
  belongs_to :tutor
  belongs_to :study
  has_one :study_plan, :order => 'created_on desc',
   :conditions => 'admited_on is not null and study_plans.actual = 1'
  has_one :disert_theme, :conditions => 'disert_themes.actual = 1'
  has_one :final_exam_term
  has_one :defense
  has_many :exams
  belongs_to :coridor
  belongs_to :department
  has_many :interupts, :order => 'created_on desc'
  has_one :interupt, :order => 'created_on desc'
  has_many :extra_scholarships, :conditions => "scholarships.payed_on IS NULL"
  has_one :regular_scholarship, :conditions => "scholarships.payed_on IS NULL", 
    :order => 'updated_on desc'
  has_many :payed_scholarships, :class_name => 'Scholarship',
    :conditions => 'payed_on IS NOT NULL'
  has_many :scholarships
  has_one :approvement, :class_name => 'FinalExamApprovement',
    :foreign_key => 'document_id'

  validates_presence_of :student
  validates_presence_of :tutor
  validates_presence_of :coridor
  validates_presence_of :study
  validates_presence_of :department
  validates_presence_of :enrolled_on
  validates_numericality_of :account_number, :only_integer => true, :allow_nil => true
  validates_numericality_of :account_bank_number, :only_integer => true, :allow_nil => true

  I18n::t(:message_0, :scope => [:txt, :model, :index])
  I18n::t(:message_1, :scope => [:txt, :model, :index])

  def validate
    if account_number
      if account_number_prefix
        pre_sum = 0
        account_number_prefix.split('').reverse.each_with_index do |c, j|
          pre_sum += c.to_i * PREFIX_WEIGHTS[j]
        end
        unless (pre_sum % 11) == 0
          errors.add(:account_number_prefix, t(:message_2, :scope => [:txt, :model, :index]))
        end
      end
      if account_number.size > 10 && account_number =~ /[0-9]/
        errors.add(:account_number, t(:message_3, :scope => [:txt, :model, :index]))
      else
        acc_sum = 0
        account_number.split('').reverse.each_with_index do |c, j|
          acc_sum += c.to_i * ACCOUNT_WEIGHTS[j]
        end
        unless (acc_sum % 11) == 0
          errors.add(:account_number, t(:message_4, :scope => [:txt, :model, :index]))
        end
      end
    end
    if final_exam_passed_on && !study_plan.all_subjects_finished?
      errors.add(:final_exam_passed_on, t(:message_5, :scope => [:txt, :model, :index]))
    end
  end

  # returns semesteer of the study
  def semester
    if @semester
      return @semester
    else
      if finished?
        time = finished_on.to_time - enrolled_on.to_time
      else
        time = Time.now - enrolled_on
      end
      if self.interupt 
        time -= interrupted_time
      end
      return @semester = time.div(6.month) + 1
    end
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
    faculty.dean
  end

  # returns if study is finished
  def finished?
    !finished_on.nil? && finished_on.to_time < Date.today.to_time
  end

  # returns if study is absolved
  def absolved?(date = Date.today)
    disert_theme && disert_theme.defense_passed?(date)
  end

  # returns true if interupt just admited
  def admited_interupt?
    interupt && !interupted? && !interupt.finished?
  end

  # returns if stduy plan is interupted
  def interupted?
    interupted_on && interupted_on < Time.now #&& interupt && !interupt.finished?
  end

  # returns true if studen claimed for final exam
  def claimed_for_final_exam?
    claimed_final_application? && approved?
  end

  # returns statement if this index waits for approvement from person
  def statement_for(user)
    unless status == t(:message_6, :scope => [:txt, :model, :index]) || status == t(:message_7, :scope => [:txt, :model, :index])
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
          study_plan.approvement ||= StudyPlanApprovement.create(:document_id => study_plan.id)
          if study_plan.approvement.prepares_statement?(user)
            return study_plan.approvement.prepare_statement(user)
          end
        elsif study_plan.waits_for_actual_atestation?
          if !study_plan.atestation || !study_plan.atestation.is_actual?
            study_plan.atestation = Atestation.create(:document_id => study_plan.id)
          end
          return study_plan.atestation.prepare_statement(user)
        end
      end
    end
  end

  # returns statement if this index waits for approvement from person
  def waits_for_statement?(user)
    unless status == t(:message_8, :scope => [:txt, :model, :index]) || status == t(:message_9, :scope => [:txt, :model, :index])
      if claimed_final_application?
        temp_approvement = self.approvement ||= FinalExamApprovement.create
      elsif admited_interupt?
        temp_approvement = interupt.approvement ||= InteruptApprovement.create
      elsif study_plan && !study_plan.approved?
        temp_approvement = study_plan.approvement ||= StudyPlanApprovement.create
      elsif study_plan && study_plan.approved? &&
        study_plan.waits_for_actual_atestation?
        if !study_plan.atestation || !study_plan.atestation.is_actual?
          temp_approvement = study_plan.atestation = Atestation.create(:document_id => study_plan.id)
        else
          temp_approvement = study_plan.atestation 
        end
      end
      temp_approvement && temp_approvement.prepares_statement?(user)
    end
  end

  # returns all indices for person
  # accepts Base.find options. Include and order for now
  def self.find_for(user, options ={})
    if user.has_one_of_roles?(['admin', 'vicerector','supervisor'])
      if options[:only_tutor]
        conditions = [TUTOR_COND.clone, user.person.id]
      elsif options[:faculty] && options[:faculty] != '0'
        faculty = options[:faculty].is_a?(Faculty) ? options[:faculty] : \
          Faculty.find(options[:faculty])
        conditions = [DEPARTMENTS_COND.clone, faculty.departments]
      else
        #TODO must be there?
        conditions  = ['NULL IS NULL']
      end
    elsif user.has_one_of_roles?(['dean', 'faculty_secretary'])
      conditions = [DEPARTMENTS_COND.clone, user.person.faculty.departments]
    elsif user.has_one_of_roles?(['leader', 'department_secretary'])
      conditions = [DEPARTMENTS_COND.clone, user.person.department.id]
    elsif user.has_role?('tutor')
      conditions = [TUTOR_COND.clone, user.person.id]
    else
      #TODO must be there?
      conditions = ["NULL IS NOT NULL"]
    end
    options[:include] ||= []
    options[:include] << [:study_plan, :student, :disert_theme, :department,
                           :study, :coridor, :interupt]
    if options[:conditions]
      conditions.first.sql_and(options[:conditions].first)
      conditions.concat(options[:conditions][1..-1])
    end
    if options[:unfinished]
      conditions.first.sql_and(NOT_FINISHED_COND)
      conditions << get_time_condition(options[:unfinished])
    elsif finished_time = options.delete(:finished)
      conditions.first.sql_and(FINISHED_COND)
      conditions << get_time_condition(finished_time)
    end
    if options[:not_interupted]
      conditions.first.sql_and(NOT_INTERUPTED_COND)
      conditions << get_time_condition(options[:not_interupted])
    end
    if options[:enrolled]
      conditions.first.sql_and(ENROLLED_COND)
      conditions << get_time_condition(options[:enrolled])
    end
    if options[:not_absolved]
      conditions.first.sql_and(NOT_ABSOLVED_COND)
      conditions << options[:not_absolved]
    end
    if search = options.delete(:search)
      search = "%s%%" % search
      conditions.first.sql_and(LASTNAME_COND)
      conditions << search
    end
    conditions.first.sql_and(PRESENT_COND) if options[:present]
    find(:all, :conditions => conditions, :order => options[:order],
        :include => options[:include])
  end

  # finds only indices tutored by user
  def self.find_tutored_by(user, options={})
    #commented is old style of searching:
    #options[:conditions] = [TUTOR_COND.clone, user.person.id]
    options[:order] = 'people.lastname'
    options[:include] ||= []
    options[:include] << [:student]
    #find_for(user, options) 
    conditions = [TUTOR_COND.clone, user.person.id]
    find(:all, :conditions => conditions, :order => options[:order],
        :include => options[:include])
  end

  # returns all indices which waits for approvement from persons 
  # only for tutors, leader a deans
  def self.find_waiting_for_statement(user, options = {})
    sql = <<-SQL
      (study_plans.approved_on is null or disert_themes.approved_on is null \
      or study_plans.last_atested_on is null or indices.interupted_on is null or \
      study_plans.last_atested_on < ?) and (indices.finished_on is null or \
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
        i.waits_for_statement?(user) ||
        i.claimed_final_application?
      end
    elsif user.has_one_of_roles?(['tutor', 'leader', 'dean'])
      result.select {|i| i.waits_for_statement?(user)} 
    end
  end

  # search on selected criteria
  def self.find_by_criteria(options = {})
    conditions = ['']
    today = Date.today
    if options[:department] && options[:department].to_i != 0
      conditions.first.sql_and(DEPARTMENTS_COND)
      conditions << options[:department]
    elsif options[:coridor] && options[:coridor].to_i != 0
      conditions.first.sql_and(CORRIDOR_COND)
      conditions << options[:coridor]
    end
    if options[:form] && options[:form].to_i != 0
      conditions.first.sql_and(STUDY_COND)
      conditions << options[:form]
    end
    if options[:status].to_i != 0 && options[:study_status].to_i == 0
      options[:study_status] = 1
    end
    if options[:study_status] && options[:study_status].to_i != 0
      case options[:study_status].to_i
      when 1, 5
        conditions.first.sql_and(NOT_FINISHED_COND).sql_and(NOT_INTERUPTED_COND)
        conditions << ([today] * 2)
      when 2
        conditions.first.sql_and(FINISHED_COND)
        conditions << today
      when 3
        conditions.first.sql_and(INTERUPTED_COND).sql_and(FINISHED_COND)
        conditions << [today]
      when 4
        conditions.first.sql_and(ABSOLVED_COND)
      when 6
        conditions.first.sql_and(PASSED_FINAL_COND)
      end
    end
    indices = Index.find_for(options[:user], :conditions => conditions.flatten, 
                            :faculty => options[:faculty], 
                            :order => options[:order])
    year = options[:year].to_i
    if options[:study_status].to_i == 5
      year = 4
    end
    if year != 0 
      if year == 4
        indices.reject! {|i| i.year < 4}
      else
        indices.reject! {|i| i.year != year}
      end
    end
    if options[:status] && options[:status].to_i != '0'
      case options[:status].to_i
      when 1
        indices.reject! {|i| i.study_plan && i.study_plan.admited?}
      when 2
        indices.reject! {|i| !i.study_plan || !i.study_plan.admited? }
      when 3
        indices.reject! {|i| i.study_plan_last_approver != Tutor}
      when 4
        indices.reject! {|i| i.study_plan_last_approver != Leader}
      when 5
        indices.reject! {|i| i.study_plan_last_approver != Dean}
      end
    end
    return indices
  end

  def self.find_studying_for(user, options = {})
    opts = {:unfinished => true, :not_interupted => true} 
    opts[:order] = options[:order] || 'people.lastname'
    return find_for(user, opts)
  end

  def self.find_for_scholarship(user, opts = {})
    paying_date =  (Time.now - 3.week)
    opts.update({:unfinished => paying_date, :not_interupted => paying_date,
                 :enrolled => paying_date, :not_absolved => paying_date, :include => [:extra_scholarships]})
    return find_for(user, opts)
  end

  # find with all relation included
  def self.find_with_all_included(idx)
    inc = [:study_plan, :disert_theme, :interupts, :coridor, :study, :student,
          :tutor, :department, :approvement]
    return self.find(idx, :include => inc, :order => 'interupts.created_on desc')
  end

  # returns status of index
  def status
    @status ||= if disert_theme && disert_theme.defense_passed?
      I18n::t(:message_10, :scope => [:txt, :model, :index])
    elsif final_exam_passed?
      I18n::t(:message_11, :scope => [:txt, :model, :index])
    elsif finished?
      I18n::t(:message_12, :scope => [:txt, :model, :index])
    elsif interupted?
      I18n::t(:message_13, :scope => [:txt, :model, :index])
    elsif continues?
      I18n::t(:message_14, :scope => [:txt, :model, :index])
    else
      I18n::t(:message_15, :scope => [:txt, :model, :index])
    end
    return @status
  end

  # returns true if index have year more than 3
  def continues?
    year > 3
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
  def study_plan_last_approver
    if study_plan
      study_plan.last_approver
    end
  end

  # returns full account number
  def full_account_number
    if account_number_prefix && !account_number_prefix.empty? && account_number_prefix != '000000'
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

  # TODO add transactions
  # interupts study with date
  def end_interupt!(end_date)
    update_attribute('interupted_on', nil)
    if end_date.is_a? Hash
      end_date = Time.local(end_date['year'].to_i,
                           end_date['month'].to_i).end_of_month
    end
    interupt.update_attribute('finished_on', end_date)
  end

  def status_class
    if finished? 
      'finished' 
    elsif absolved?
      'absolved'
    else
      ''
    end
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
    claim_date = scholarship_claimed_at
    claim_date && claim_date > TermsCalculator.this_year_start &&
      !scholarship_approved? && !scholarship_canceled?
  end

  def scholarship_claimed?
    scholarship_claimed_at.nil?
  end

  def scholarship_approved?
    scholarship_approved_at?
  end

  def scholarship_canceled?
    scholarship_canceled_at?
  end

  def claim_accommodation_scholarship!
    update_attribute(:scholarship_claimed_at, Time.now)
  end

  def approve_accommodation_scholarship!
    update_attribute(:scholarship_approved_at, Time.now)
  end

  def cancel_accommodation_scholarship!
    update_attribute(:scholarship_canceled_at, Time.now)
  end

  # returns sum of extra scholarships
  def extra_scholarship_sum
    extra_scholarships.inject(0) do |sum, s|
      sum += s.amount
    end
  end

  # return faculty 
  def faculty
    department.faculty
  end

  # returns true if study is present
  def present_study?
    study.id == 1
  end

  def self_payer?
    payment_id == 2
  end
  
  def foreigner?
    payment_id == 3
  end

  def has_regular_scholarship?
    present_study? && !self_payer?
  end

  def has_extra_scholarship?
    extra_scholarships && !extra_scholarships.empty? && extra_scholarship_sum > 0
  end

  def regular_scholarship_or_create
    regular_scholarship || RegularScholarship.create_for(self)
  end

  def claim_final_exam!(final_areas = nil)
    if final_areas
      study_plan.final_areas = final_areas
      study_plan.save
    end
    update_attribute(:final_application_claimed_at, Time.now)
  end

  def claim_defense!
    update_attribute(:defense_claimed_at, Time.now)
  end

  def defense_claimed?
    !defense_claimed_at.nil?
  end

  def claimed_final_application?
    !final_application_claimed_at.nil?
  end

  def claim_final_application!
    update_attribute(:final_application_claimed_at, Time.now)
  end

  def final_term_created?
    !final_exam_term.nil?
  end

  def defense_created?
    !defense.nil?
  end

  # for approvement purposes
  def index
    self
  end

  def send_final_exam_invitation!
    update_attribute(:final_exam_invitation_sent_at, Time.now)
  end

  def final_exam_invitation_sent?
    !final_exam_invitation_sent_at.nil?
  end

  def send_defense_invitation!
    update_attribute(:defense_invitation_sent_at, Time.now)
  end

  def defense_invitation_sent?
    !defense_invitation_sent_at.nil?
  end

  def study_name
    study.name
  end

  def student_name
    student.display_name
  end

  def final_exam_passed?
    !final_exam_passed_on.nil?
  end

  def final_exam_passed!(date = Date.today)
    update_attribute(:final_exam_passed_on, date)
  end

  def prepare_study_plan
    sp = build_study_plan
    sp.final_areas = {'cz' => 
                      {'1' => '', '2' => '', '3' => '', '4' => '', '5' => ''},
                      'en' => 
                      {'1' => '', '2' => '', '3' => '', '4' => '', '5' => ''}}
    return sp
  end

  def to_wsdl_hash
    return {
      'index-id' => self.id,
      'student-uic' => self.student.uic,
      'faculty-id' => self.faculty.id,
      'department-id' => self.department.id,
# TODO change 
      'study-status' => 'S',
      'status-from' => self.index.updated_on,
      'status-to' => ''
    }
  end

  def has_study_plan_and_actual_atestation?
    study_plan && index.study_plan.atested_actual? && study_plan.atestation.dean_statement
  end

  def has_any_scholarship?
    return ((has_regular_scholarship? && regular_scholarship_or_create.amount > 0) || (has_extra_scholarship? && extra_scholarship_sum > 0))
  end

  private
  def self.get_time_condition(time)
    if time.is_a? Time
      time
    else
      Time.now
    end
  end
end
