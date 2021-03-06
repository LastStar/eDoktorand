require 'genderize'

class Candidate < ActiveRecord::Base
  include Genderize

  belongs_to :specialization
  belongs_to :department
  belongs_to :study
  belongs_to :student
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key => 'title_after_id'
  belongs_to :exam_term
  belongs_to :tutor
  has_one :admittance
  belongs_to :language1, :class_name => 'Subject',
    :foreign_key => 'language1_id'
  belongs_to :language2, :class_name => 'Subject',
    :foreign_key => 'language2_id'
  belongs_to :admittance_theme

  before_save :strip_birth_number

  validates_presence_of :firstname, :message => I18n::t(:name_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :lastname, :message => I18n::t(:last_name_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :birth_at, :message => I18n::t(:birth_at_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :email, :message => I18n::t(:email_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :street, :message => I18n::t(:street_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :city, :message => I18n::t(:city_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :zip, :message => I18n::t(:zip_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :state, :message => I18n::t(:state_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :university, :message => I18n::t(:university_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :faculty, :message => I18n::t(:faculty_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :studied_specialization, :message => I18n::t(:studied_specialization_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :birth_number, :message => I18n::t(:birth_number_must_be_present, :scope => [:model, :candidate])
  validates_presence_of :number, :message => I18n::t(:number_must_be_present, :scope => [:model, :candidate])
  validates_format_of :email, :with => /^\s*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*$/i,
    :on => :create, :message => I18n::t(:wrong_email_format, :scope => [:model, :candidate])

  #TODO rename with tt
  #TODO spec it
  named_scope :admited, :conditions => 'admited_on is not null'
  named_scope :finished, :conditions => 'finished_on is not null'
  named_scope :finished_before, lambda{|date|
    {:conditions => ['finished_on < ?', date]}
  }
  named_scope :from_faculty, lambda {|faculty|
    {:conditions => ['specialization_id in (?)', faculty.specializations]}
  }

  # strips all spaces from birth number
  def strip_birth_number
    self.birth_number.strip!
  end

  # validates if languages are not same
  def validate
    errors.add_to_base(I18n::t(:languages_must_be_different, :scope => [:model, :candidate])) if language1_id == language2_id
    # TODO check if used then remove vvvvv
    errors.add_to_base(I18n::t(:candidate_must_be_registered_before_invite, :scope => [:model, :candidate])) if
    !finished? && invited?
    errors.add_to_base(I18n::t(:candidate_must_be_invited_before_admit, :scope => [:model, :candidate])) if
    !invited? && admited?
    errors.add_to_base(I18n::t(:candidate_must_be_admited_before_enroll, :scope => [:model, :candidate])) if
    !admited? && enrolled?
    #^^^^^^^^
    if admittance_theme
      if admittance_theme.department != department
      errors.add(:admittance_theme,
                  I18n::t(:theme_department_mismatch,
                          :scope => [:model, :candidate]))
      end
    elsif specialization && AdmittanceTheme.has_for?(specialization)
      errors.add(:admittance_theme,
                  I18n::t(:theme_missing,
                          :scope => [:model, :candidate]))
    end
  end

  def validate_on_create
    self.birth_number = birth_number.strip
    if state == "CZ" || state == "SK"
      if !(birth_number =~ /^\d+$/) || (birth_number.size == 10 && birth_number.to_i.remainder(11) != 0)
        errors.add(:birth_number, I18n::t(:wrong_birth_number_format, :scope => [:model, :candidate]))
      end
    end
  end

  def validate_on_update
    if state == "CZ" || state == "SK"
      if birth_number.to_i.remainder(11) != 0
        errors.add(:birth_number, I18n::t(:wrong_birth_number_format, :scope => [:model, :candidate]))
      end
    end
  end

  # returns candidate's hash
  def hash
    str = "%s%i%s" % [self.lastname.first, self.id, self.firstname.first]
    return '#' + Digest::SHA256.hexdigest(str)[0..8].to_i(16).to_s
  end

  # finishes candidate
  def finish!
    self.update_attribute(:finished_on, Time.now)
  end

  # checks if candidate is allready finished
  def finished?
    return !self.finished_on.nil?
  end

  # returns name for displaying
  def display_name
  	 arr = self.title_before ? [self.title_before.label] : []
    arr << [ self.firstname, self.lastname + (self.title_after ? ',' : '')]
    arr << self.title_after.label if self.title_after
    return arr.join(' ')
  end

  # returns address for displaying
  def address
    return [[self.street, self.number.to_s].join(' '), self.city, self.zip].join(', ')
  end

  # returns address for sending
  def sending_address
    return [[self.street, self.number.to_s].join(' '), [self.zip,
    self.city].join(' ')].join('<br/>')
  end

  # returns postal address for displaying
  def postal_address
    return [[self.postal_street, self.postal_number.to_s].join(' '), self.postal_city, self.postal_zip].join(', ')
  end

  # returns postal address for displaying
  def sending_postal_address
    return [[self.postal_street, self.postal_number.to_s].join(' '),
    [self.postal_zip, self.postal_city].join(' ')].join('<br/>')
  end

  # invites candidate to entrance exam
  def invite!
    self.update_attribute('invited_on', Time.now)
  end

  # checks if candidate is allready invited
  def invited?
    !self.invited_on.nil?
  end

  # admits candidate to study.
  def admit!
    self.update_attribute('admited_on', Time.now)
  end

  # checks if candidate is allready admited
  def admited?
    !self.admited_on.nil?
  end

  # enroll candidate to study and returns new student based on
  # candidates details.
  def enroll!(enrolled_on, study_start_on)
    self.update_attribute('enrolled_on', Time.now)
    return new_student(enrolled_on, study_start_on)
  end

  # checks if candidate is allready enrolled
  def enrolled?
    !self.enrolled_on.nil?
  end

  # sets candidate ready for admition
  def ready!
    self.update_attribute('ready_on', Time.now)
    self.save
  end

  # checks if student is ready
  def ready?
    !self.ready_on.nil?
  end

  # sets candidate reject for admition
  def reject!
    self.update_attribute('rejected_on', Time.now)
  end

  def delete_reject!
    if !self.rejected_on.nil?
      self.update_attribute('rejected_on', nil)
    end
  end

  # checks if student is reject
  def rejected?
    !self.rejected_on.nil?
  end

  # TODO redone with aggregations
  # returns email like contact object
  def contact_email
    return Contact.create(:name => self.email, :contact_type_id => 1)
  end

  # returns phone like contact object
  def contact_phone
    return Contact.create(:name => self.phone, :contact_type_id => 2)
  end

  # returns new address with attributes set by self
  def create_address(id)
    add = Address.new do |a|
      a.student_id = id
      a.street = self.street
      a.desc_number = self.number
      a.city = self.city
      a.zip = self.zip
      a.address_type = AddressType.find(1)
    end
    add.save
  end

  # returns new postal address with attributes set by self
  def create_postal_address(id)
    if self.postal_city
      add = Address.new do |a|
        a.student_id = id
        a.street = self.postal_street
        a.desc_number = self.postal_number
        a.city = self.postal_city
        a.zip = self.postal_zip
        a.address_type = AddressType.find(2)
      end
      add.save
    end
  end

  # creates student and index from self
  def new_student(enrolled_on, study_start_on)
    enrolled_on = Date.parse(enrolled_on) unless enrolled_on.is_a?(Date)
    Dean.columns #Table inheritance biting our ass again
    uic_getter = UicGetter.new
    unless student = Student.find_by_birth_number(self.birth_number.strip)
      student = Student.new
      if self.state == 'CZ' || self.state == "SK"
        student.uic = uic_getter.get_uic(self.birth_number)
      else
        student.uic = uic_getter.get_foreign_uic(self.birth_number)
      end
    end
    student.firstname = self.firstname
    student.lastname = self.lastname
    student.birth_on = self.birth_on
    student.birth_number = self.birth_number
    student.citizenship = student.state = self.state
    student.birth_place = self.birth_at
    student.title_before = self.title_before
    student.title_after = self.title_after
    student.street = self.street
    student.desc_number = self.number
    student.city = self.city
    student.country = self.address_state
    student.zip = self.zip
    student.postal_street = self.postal_street
    student.postal_city = self.postal_city
    student.postal_desc_number = self.postal_number
    student.postal_country = self.postal_state
    student.postal_zip = self.postal_zip
    student.email = self.email
    student.phone = self.phone if self.phone
    student.sex = self.sex
    student.marital_status = 'S'
    student.save!
    index = Index.new
    index.student = student
    index.department = self.department
    index.specialization = self.specialization
    index.tutor = self.tutor
    index.study = self.study
    index.enrolled_on = enrolled_on
    index.payment_id = self.foreign_pay ? 0 : 1
    index.study_start_on = study_start_on
    index.student = student
    if Date.today < enrolled_on
      index.enrolling_im_index
    else
      index.update_im_index
    end
    return student
  end

  def admitting_faculty
    specialization.faculty
  end

  # prepares conditions for paginate functions
  def self.prepare_conditions(filter, faculty, user, specialization = nil)
    if user.has_one_of_roles?(['vicerector', 'university_secretary'])
      conditions = ["specialization_id in (?) AND finished_on IS NOT NULL",
                    Specialization.find(:all)]
    elsif user.has_one_of_roles?(['faculty_secretary', 'dean'])
      conditions = ["specialization_id in (?) AND finished_on IS NOT NULL",
                    faculty.specializations]
    elsif user.has_role?('board_chairman')
      conditions = ["specialization_id = ? AND finished_on IS NOT NULL",
                    user.person.specialization]
    else
      conditions = ["department_id = ? AND finished_on IS NOT NULL",
                    user.person.department.id]

    end

    conditions.first << filter_conditions(filter)

    if specialization
       conditions.first << " AND specialization_id = #{specialization}"
    end
    return conditions
  end

  # returns all candidates by filter
  def self.find_all_finished(options, faculty)
    conditions = ["specialization_id in (?) AND finished_on IS NOT NULL",
                  faculty.specializations]
    conditions.first << filter_conditions(options['filter'])
    if options['specialization']
      conditions.first << " AND specialization_id = ?"
      conditions << options['specialization']
    end
    Candidate.find(:all, :order => options['category'],
      :conditions => conditions)
  end

  def self.find_all_finished_by_session_category(options, faculty, category, user)
    if user.has_role?('vicerector')
      conditions = ["specialization_id in (?) AND finished_on IS NOT NULL",
                    Specialization.find(:all)]
    else
      conditions = ["specialization_id in (?) AND finished_on IS NOT NULL",
                    faculty.specializations]
    end
    conditions.first << filter_conditions(options['filter'])
    if options['specialization']
      conditions.first << " AND specialization_id = ?"
      conditions << options['specialization']
    end
    Candidate.find(:all, :order => category,
      :conditions => conditions)
  end

  # delete candidate, fill finished_on to nil
  def unfinish!
    self.update_attribute(:finished_on, nil)
  end

  def self.filter_conditions(filter)
    case filter
    when 'unready':' AND ready_on IS NULL'
    when 'ready': ' AND ready_on IS NOT NULL AND invited_on IS NULL'
    when 'invited': ' AND invited_on IS NOT NULL AND admited_on IS NULL'
    when 'admited': ' AND admited_on IS NOT NULL AND enrolled_on IS NULL'
    when 'enrolled': ' AND enrolled_on IS NOT NULL'
    when nil: ''
    else
      ''
    end
  end

  def present_study?
    study_id == 1
  end

  # toggles foreign payment
  def toggle_foreign_pay
    new = foreign_pay ? nil : 1
    update_attribute(:foreign_pay, new)
  end
end
