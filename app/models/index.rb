# FIXME with arel in rails 3
class String
  def sql_and(chunk)
    if self.empty?
      self << chunk
    elsif !chunk.strip.empty?
      self << ' and ' << chunk
    end
  end
end

class UnknownState < Exception
end

class Index < ActiveRecord::Base
  include Approvable
  PREFIX_WEIGHTS = [1, 2, 4, 8, 5, 10]
  ACCOUNT_WEIGHTS = [1, 2, 4, 8, 5, 10, 9, 7, 3, 6]
  #TODO name scope them all
  NOT_FINISHED_COND = <<-SQL
    (indices.finished_on is null or indices.finished_on > ?)\
    and disert_themes.defense_passed_on is null
  SQL
  DEPARTMENTS_COND = "indices.department_id in (?)"
  TUTOR_COND = "indices.tutor_id = ?"
  SPECIALIZATION_COND = "indices.specialization_id = ?"
  NOT_INTERRUPTED_COND = <<-SQL
    (indices.interrupted_on is null or indices.interrupted_on > ?)
  SQL
  ENROLLED_COND = "indices.enrolled_on < ?"
  NOT_ABSOLVED_COND = <<-SQL
    (disert_themes.defense_passed_on is null\
    or disert_themes.defense_passed_on >= ?)
  SQL
  LASTNAME_COND = "people.lastname like ?"
  PRESENT_COND = "indices.study_id = 1"
  FINISHED_COND = <<-SQL
    indices.finished_on is not null and indices.finished_on < ?
  SQL
  INTERRUPTED_COND = "indices.interrupted_on is not null"
  ABSOLVED_COND = "disert_themes.defense_passed_on is not null"
  PASSED_FINAL_COND = "indices.final_exam_passed_on is not null"
  CORRIDOR_COND = "indices.specialization_id = ?"
  STUDY_COND = " indices.study_id = ?"

  belongs_to :student, :foreign_key => 'student_id'
  belongs_to :tutor
  belongs_to :study
  has_one :study_plan, :order => 'created_on desc',
   :conditions => 'admited_on is not null and study_plans.actual = 1'
  has_one :disert_theme, :conditions => 'disert_themes.actual = 1'
  has_one :final_exam_term, :order => 'created_on desc',
    :conditions => 'not_passed_on is null'
  has_one :not_passed_final_exam_term, :conditions => 'not_passed_on is not null',
    :class_name => 'FinalExamTerm'
  has_one :defense, :order => 'created_on desc',
    :conditions => 'not_passed_on is null'
  has_one :not_passed_defense, :conditions => 'not_passed_on is not null',
      :class_name => 'Defense'
  has_many :exams
  belongs_to :specialization
  belongs_to :department
  has_many :interrupts, :order => 'created_on', :class_name => 'StudyInterrupt'
  has_many :extra_scholarships, :conditions => {:scholarship_month_id => ScholarshipMonth.current.try(:id)}
  has_one :regular_scholarship, :conditions => {:scholarship_month_id => ScholarshipMonth.current.try(:id)}
  has_many :scholarships
  has_one :im_index, :dependent => :destroy

  validates_presence_of :student
  validates_presence_of :tutor
  validates_presence_of :specialization
  validates_presence_of :study
  validates_presence_of :department
  validates_presence_of :enrolled_on
  validates_numericality_of :account_number, :only_integer => true, :allow_nil => true
  validates_numericality_of :account_bank_number, :only_integer => true, :allow_nil => true

  after_save :update_im_index

  # update ImIndex
  def update_im_index
    prepare_im_index unless im_index
    im_index.get_index_attributes
    im_index.save
  end

  # creates ImIndex
  def prepare_im_index
    build_im_index unless im_index
    im_index.index = self
    im_index.get_index_attributes
    im_index
  end

  def enrolling_im_index
    build_im_index
    im_index.index = self
    im_index.get_index_attributes
    im_index.academic_year = TermsCalculator.idm_next_year
    im_index.study_status_from = TermsCalculator.next_year_start.to_date
    im_index.study_status_to = TermsCalculator.next_year_end.to_date
    im_index.save
    im_index
  end

  def index
    self
  end

  # return last interrupt
  def interrupt
    @interrupt ||= interrupts.reject(&:new_record?).sort { |x, y|
      x.created_on <=> y.created_on}.last
  end

  def older_interrupts
    (interrupts.sort {|x, y| x.created_on <=> y.created_on} - [interrupt])
  end

  # returns describe_error for bad index
  # TODO this mess must go
  def describe_error
     message = ""
    if self.account_number == nil
              message = message + I18n.t(:wrong_or_missing_account_number, :scope => [:model, :index]) + " "
    end
    if self.account_bank_number == nil
              message = message + I18n.t(:wrong_or_missing_account_bank_number, :scope => [:model, :index]) + " "
    end
    if self.student.uic == nil
          message = message + I18n.t(:missing_uic, :scope => [:model, :index]) + " "
    end
    if self.sident == -666
          message = message + I18n.t(:missing_sident_666, :scope => [:model, :index]) + " "
    end
    if self.sident == nil
          message = message + I18n.t(:missing_sident, :scope => [:model, :index]) + " "
    end
    return message

  end

  # returns if index is bad
  def bad_index?
     if self.account_number == nil || self.account_bank_number == nil ||
      self.student.uic == nil || self.sident == -666 || self.sident == nil
        if self.has_any_scholarship?
          return true
        end
     end
    return false
  end

  def validate
    if account_number
      if account_number_prefix
        pre_sum = 0
        account_number_prefix.split('').reverse.each_with_index do |c, j|
          pre_sum += c.to_i * PREFIX_WEIGHTS[j]
        end
        if account_number_prefix !~ /^[0-9]*$/ || (pre_sum % 11) != 0
          errors.add(:account_number_prefix, I18n::t(:wrong_account_number_prefix_format, :scope => [:model, :index]))
        end
      end
      if account_number.size > 10 || !account_number =~ /^[0-9]*$/
        errors.add(:account_number, I18n.t(:wrong_account_number_format, :scope => [:model, :index]))
      else
        acc_sum = 0
        account_number.split('').reverse.each_with_index do |c, j|
          acc_sum += c.to_i * ACCOUNT_WEIGHTS[j]
        end
        unless (acc_sum % 11) == 0
          errors.add(:account_number, I18n.t(:wrong_account_number_format, :scope => [:model, :index]))
        end
      end
    end
    if final_exam_passed_on && !study_plan.all_subjects_finished?
      errors.add(:final_exam_passed_on, I18n.t(:all_subjects_are_not_finished, :scope => [:model, :index]))
    end
  end

  # returns real number of study years
  def real_study_years
    if finished?
      end_date = finished_on.to_time
    elsif absolved?
      end_date = disert_theme.defense_passed_on.to_time
    else
      end_date = Time.now
    end
    return (end_date - enrolled_on.to_time).div(1.year) + 1
  end

  # returns semesteer of the study
  def semester
    time = time_from_enrollment
    @semester = time.div(1.year / 2) + 1
    @semester = 1 if @semester <= 0
    return @semester
  end

  def time_from_enrollment
    if finished?
      end_date = finished_on.to_time
    elsif absolved?
      end_date = disert_theme.defense_passed_on.to_time
    else
      end_date = Time.now
    end
    time = (end_date - enrolled_on.to_time)
    if self.interrupt
      time -= interrupted_time
    end
    return time
  end

  def days_left
    @days_left = (((specialization.study_length.years - time_from_enrollment) / 1.day).to_i) + 1
  end

  def nominal_length
    if Time.now < enrolled_on
      return 'studium ještě nezačalo'
    end

    if days_left < 0
      days = -days_left
      case days
      when 1
        return "přes jeden den"
      when 2..4
        return "přes #{days} dny"
      else
        return "přes #{days} dní"
      end
    end
    if days_left < 30
      case days_left
      when 1
        return "zbývá poslední den"
      when 2..4
        return "zbývají #{days_left} dny"
      else
        return "zbývá #{days_left} dní"
      end
    end
    years = (time_from_enrollment/1.year).to_i
    months = ((time_from_enrollment%1.year)/1.month).to_i
    case years
    when 0
      years = ''
    when 1
      years = "1 rok"
    when 2..4
      years = "%i roky" % years
    else
      years = "%i let" % years
    end
    case months
    when 0
      months = ''
    when 1
      months = " a 1 měsíc"
    when 2..4
      months = " a %i měsíce" % months
    else
      months = " a %i měsíců" % months
    end

    if years.present? && months.present?
      return "%s a %s" % [years, months]
    elsif years.present?
      return years
    end
    return months
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
  def finished?(date = Date.today)
    !finished_on.nil? && finished_on < date
  end

  # returns if study is absolved
  def absolved?(date = Date.today)
    disert_theme && disert_theme.defense_passed?(date.to_date)
  end

  # returns true if interrupt just admited
  def admited_interrupt?
    interrupt && !interrupted? && !interrupt.finished?
  end

  # returns if stduy plan is interrupted
  def interrupted?(date = Date.today)
    interrupted_on && interrupted_on < date #&& interrupt && !interrupt.finished?
  end

  # returns true if studen claimed for final exam
  def claimed_for_final_exam?
    claimed_final_application?
  end

  # returns statement if this index waits for approval from person
  # TODO this method needs specs!!!
  def statement_for(user)
    #TODO move this two ors to it's own status method
    unless status == absolved? || interrupted?
      if admited_interrupt?
        interrupt.approval ||= InterruptApproval.create
        if interrupt.approval.prepares_statement?(user)
          return interrupt.approval.prepare_statement(user)
        end
      elsif study_plan
        if !study_plan.approved?
          study_plan.approval ||= StudyPlanApproval.create(:document_id => study_plan.id)
          if study_plan.approval.prepares_statement?(user)
            return study_plan.approval.prepare_statement(user)
          end
        elsif study_plan.waits_for_actual_attestation?
          if !study_plan.attestation || !study_plan.attestation.is_actual?
            study_plan.attestation = Attestation.create(:document_id => study_plan.id)
          end
          return study_plan.attestation.prepare_statement(user)
        end
      end
    end
  end

  # returns statement if this index waits for approval from person
  # TODO this method needs specs!!!
  def waits_for_statement?(user)
    #TODO move this two ors to it's own status method
    unless absolved? || interrupted?
      if admited_interrupt?
        temp_approval = interrupt.approval ||= InterruptApproval.create
      elsif !final_exam_passed? && study_plan && !study_plan.approved?
        temp_approval = study_plan.approval ||= StudyPlanApproval.create
      elsif !final_exam_passed? && study_plan && study_plan.approved?
        if !study_plan.attestation || !study_plan.attestation.is_actual?
          temp_approval = study_plan.attestation = Attestation.create(:document_id => study_plan.id)
        else
          temp_approval = study_plan.attestation
        end
      end
      temp_approval && temp_approval.prepares_statement?(user)
    end
  end

  # returns all indices for person
  # accepts Base.find options. Include and order for now
  def self.find_for(user, options ={})
    if user.has_role?('board_chairman') && options[:chairman]
      conditions = [SPECIALIZATION_COND.clone, user.person.specialization.id]
    elsif user.has_one_of_roles?(['admin', 'vicerector','supervisor', 'university_secretary'])
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
      options[:order] = 'people.lastname, people.firstname'
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
                           :study, :specialization, :interrupts]
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
    if options[:not_interrupted]
      conditions.first.sql_and(NOT_INTERRUPTED_COND)
      conditions << get_time_condition(options[:not_interrupted])
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
    options[:order] = 'indices.study_id, people.lastname, people.firstname'
    options[:include] ||= []
    options[:include] << [:student]
    #find_for(user, options)
    conditions = [TUTOR_COND.clone, user.person.id]
    find(:all, :conditions => conditions, :order => options[:order],
        :include => options[:include])
  end

  # finds only indices which have specialization for board chairman
  def self.chairmaned_by(user)
    opts = {:unfinished => true, :not_interrupted => true}
    opts[:order] = 'indices.study_id, people.lastname, people.firstname'
    opts[:chairman] = true
    return find_for(user, opts)
  end

  # returns all indices which waits for approval from persons
  # only for tutors, leader a deans
  def self.find_waiting_for_statement(user, options = {})
    sql = <<-SQL
      (study_plans.approved_on is null \
      or study_plans.last_attested_on is null or indices.interrupted_on is null or \
      study_plans.last_attested_on < ?) and (indices.finished_on is null or \
      indices.finished_on = '0000-00-00 00:00:00')
    SQL
    options[:conditions] = [sql,
      Attestation.actual_for_faculty(user.person.faculty)]
    options[:only_tutor] = true
    options[:unfinished] = true
    result = find_for(user, options)
    if user.has_role?('faculty_secretary')
      options[:order] = 'people.lastname, people.firstname'
      result.select do |i|
        i.waits_for_scholarship_confirmation? ||
        i.interrupt_waits_for_confirmation? ||
        i.waits_for_statement?(user) ||
        i.claimed_final_application?
      end
    elsif user.has_one_of_roles?(['tutor', 'leader', 'dean'])
      options[:order] = 'indices.study_id, people.lastname, people.firstname'
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
    elsif options[:specialization] && options[:specialization].to_i != 0
      conditions.first.sql_and(CORRIDOR_COND)
      conditions << options[:specialization]
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
      when 1
        conditions.first.sql_and(NOT_FINISHED_COND).sql_and(NOT_INTERRUPTED_COND)
        conditions << ([today] * 2)
      when 2
        conditions.first.sql_and(FINISHED_COND)
        conditions << today
      when 3
        conditions.first.sql_and(INTERRUPTED_COND).sql_and(NOT_FINISHED_COND)
        conditions << [today]
      when 4
        conditions.first.sql_and(ABSOLVED_COND)
      end
    end
    indices = Index.find_for(options[:user], :conditions => conditions.flatten,
                            :faculty => options[:faculty],
                            :order => options[:order])
    year = options[:year].to_i
    if year != 0
      if year == 5
        indices.reject! {|i| i.year < 5}
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
      when 6
        indices.reject! {|i| !i.final_exam_passed?}
      end
    end
    return indices
  end

  def self.find_studying_for(user, options = {})
    opts = {:unfinished => true, :not_interrupted => true}
    opts[:order] = options[:order] || 'indices.study_id, people.lastname, people.firstname'
    return find_for(user, opts)
  end

  def self.find_for_scholarship(user, paying_date, opts = {})
    opts.update({:unfinished => paying_date,
                 :not_interrupted => paying_date,
                 :enrolled => paying_date,
                 :not_absolved => paying_date,
                 :include => [:regular_scholarship, :extra_scholarships]})

    return find_for(user, opts)
  end

  def self.find_with_scholarship(user)
    ids = ScholarshipMonth.current.scholarships.map(&:index_id)

    conditions = ["indices.id in (?)", ids]
    if user.has_role?('faculty_secretary')
      conditions.first.sql_and("indices.department_id in (?)")
      conditions << user.person.faculty.departments.map(&:id)
    elsif user.has_role?('department_secretary')
      conditions.first.sql_and("indices.department_id = ?")
      conditions << user.person.department.id
    end

    return all(:conditions => conditions,
               :order => "people.lastname, people.firstname",
               :include => [:study, :student, :disert_theme,
               :regular_scholarship, :extra_scholarships, :department,
               :specialization])
  end

  # find with all relation included
  def self.find_with_all_included(idx)
    inc = [:study_plan, :disert_theme, :interrupts, :specialization, :study, :student,
          :tutor, :department]
    return self.find(idx, :include => inc, :order => 'study_interrupts.created_on desc')
  end

  # returns status of index
  def status(date = Date.today)
    status = if absolved?(date)
      I18n::t(:absolved, :scope => [:model, :index])
    elsif finished?(date)
      I18n::t(:finished, :scope => [:model, :index])
    elsif interrupted?(date)
      I18n::t(:interrupted, :scope => [:model, :index])
    elsif studying?(date)
      I18n::t(:studies, :scope => [:model, :index])
    else
      raise UnknownState
    end
    return status
  end

  # TODO after merge with rails3 redone with new status
  def status_code
    @status_code ||= if absolved?
      "A"
    elsif finished?
      "Z"
    elsif interrupted?
      "P"
    elsif final_exam_passed?
      "S"
    elsif continues?
      "S"
    elsif studying?
      "S"
    else
      raise UnknownState
    end
    return @status_code
  end

  def status_from
    if absolved?
      disert_theme.defense_passed_on
    elsif interrupted?
      interrupted_on
    else
      TermsCalculator.this_year_start.to_date
    end
  end

  # TODO add logic for other statuses like interrupted to and so
  def status_to
    TermsCalculator.this_year_end.to_date
  end

  # TODO redone some better way
  def payment_code
    (payment_id == 1 || payment_id.nil?) ? 1 : 7
  end

  def payment_type
    payment_id == 1 ? I18n.t(:study_in_standart_time, :scope => [:model, :index]) : I18n.t(:foreigner_pay_throught_dotation, :scope => [:model, :index])
  end

  # returns true if index have year more than 3
  def continues?
    year > specialization.study_length
  end

  def studying?(date = Date.today)
    !finished?(date) && !interrupted?(date) && !absolved?(date)
  end

  # switches study form
  # TODO add history and use date
  def switch_study!(date = Date.today)
    if study_id == 1
      update_attribute('study_id', 2)
    else
      update_attribute('study_id', 1)
    end
    update_attribute(:study_form_changed_on, date)
  end

  def switched_study?
    study_form_changed_on?
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
    interrupts.inject(0) { |sum, i| i.approved? ? (sum + i.current_duration) : sum }
  end

  # interrupts study with date
  def interrupt!(start_date)
    update_attribute('interrupted_on', start_date)
  end

  # TODO add transactions
  # interrupts study with date
  def end_interrupt!(end_date)
    update_attribute('interrupted_on', nil)
    if end_date.is_a? Hash
      end_date = Time.local(end_date['year'].to_i,
                           end_date['month'].to_i,
                           end_date['day'])
    end
    end_date = end_date.end_of_month unless interrupt.start_on_day

    interrupt.update_attribute('finished_on', end_date)
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

  def not_even_admited_interrupt?
    !interrupted? && !admited_interrupt?
  end

  def interrupt_waits_for_confirmation?
    admited_interrupt? && interrupt.approved? && !interrupt.finished? &&
      !interrupted_on
  end

  def interrupt_ended?
    !finished? && interrupt && !interrupt.finished? && Time.now > interrupt.end_on
  end

  def close_to_interrupt_end_or_after?(months = 3)
    interrupt && !interrupt.finished? && Time.now > interrupt.end_on.months_ago(months)
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
  def present_study?(date = Time.now)
    study.id == 1 || (study.id == 2 && study_form_changed_on && study_form_changed_on > date.to_date)
  end

  def self_payer?
    payment_id == 2
  end

  def foreigner?
    payment_id == 3
  end

  def has_regular_scholarship?(date = Time.now)
    present_study?(date) && !self_payer? && !absolved?(date) && !finished?(date) && !interrupted?(date)
  end

  def has_extra_scholarship?
    extra_scholarships && !extra_scholarships.empty? && extra_scholarship_sum > 0
  end

  def regular_scholarship_or_create
    regular_scholarship || RegularScholarship.create_for(self)
  end

  def claim_final_exam!
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

  #TODO should be in coresponding models
  #vvvvv
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
  #^^^^^

  def study_name
    study.name
  end

  def student_name
    student.display_name
  end

  def final_exam_passed?(date = Date.today)
    final_exam_passed_on && final_exam_passed_on < date
  end

  def final_exam_passed!(date = Date.today)
    update_attribute(:final_exam_passed_on, date)
  end

  def final_exam_not_passed!
    update_attributes(:final_application_claimed_at => nil, :final_exam_invitation_sent_at => nil)
  end

  def defense_not_passed!
    update_attributes(:defense_claimed_at => nil, :defense_invitation_sent_at => nil)
    disert_theme.update_attributes( :theses_request => nil, :theses_request_at => nil, :theses_request_response => nil, :theses_request_succesfull => nil, :theses_response => nil, :theses_response_at => nil, :theses_status => nil)
  end

  def prepare_study_plan
    sp = build_study_plan
    sp.final_areas = {'cz' =>
                      {'1' => '', '2' => '', '3' => '', '4' => '', '5' => ''},
                      'en' =>
                      {'1' => '', '2' => '', '3' => '', '4' => '', '5' => ''}}
    return sp
  end

  # returns service struct for index
  def to_service_struct
    service_struct = IndexHash.new
    service_struct.index_id = self.id
    service_struct.student_uic = self.student.uic
    service_struct.faculty_id = self.faculty.id
    service_struct.faculty_name = self.faculty.name
    service_struct.faculty_code = self.faculty.short_name
    service_struct.department_id = self.department.id
    service_struct.department_name = self.department.name
    service_struct.department_code = self.department.short_name
    service_struct.study_status = self.status
    service_struct.status_from = self.updated_on
    service_struct.status_to = ''
    service_struct.year = self.year
    service_struct.study_form = self.study_name
    service_struct.attestation = self.study_plan ? self.study_plan.last_attested_on : ''
    service_struct.specialization = self.specialization.code
    return service_struct
  end

  def has_study_plan_and_actual_attestation?
    study_plan && index.study_plan.attestation
  end

  def has_any_scholarship?(date = Date.today)
    return ((has_regular_scholarship?(date) && regular_scholarship_or_create.amount > 0) || (has_extra_scholarship? && extra_scholarship_sum > 0))
  end

  # updates index from StudentHash
  def update_with_hash(index_hash)
    return true
  end

  def confirm_intellectual_property
    update_attribute(:intellectual_property, true)
  end

  def claim_individual_study_plan!(note)
    update_attributes(:individual_application_note => note,
                      :individual_application_claimed_on => Date.today)
  end

  def claimed_individual_study_plan?
    !individual_application_claimed_on.blank?
  end

  def approve_individual!
    update_attributes(:individual_application_result => true,
                      :individual_application_decided_at => Time.now)
  end

  def cancel_individual!
    update_attributes(:individual_application_result => false,
                      :individual_application_decided_at => Time.now)
  end

  def individual_decided?
    !individual_application_decided_at.blank?
  end

  def individual_result
    if individual_decided?
      individual_application_result ? I18n::t(:approved, :scope => [:model, :index]) : I18n::t(:canceled, :scope => [:model, :index])
    end
  end

  def paid_scholarships
    sms = ScholarshipMonth.all(:conditions => "paid_at is not null")
    Scholarship.all(:conditions => ["index_id = ? and scholarship_month_id in (?)", self.id, sms.map(&:id)])
  end

  def has_interrupt_from_day?
    study_plan.try(:all_subjects_finished?) && days_left < 30
  end

  private
  def self.get_time_condition(time)
    if time.respond_to? :to_time
      time.to_time
    else
      Time.now
    end
  end
end
