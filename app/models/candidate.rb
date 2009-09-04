require 'genderize'

class Candidate < ActiveRecord::Base
  include Genderize
  
  belongs_to :coridor
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
  validates_presence_of :firstname, :message => I18n::t(:message_0, :scope => [:txt, :model, :candidate])
  validates_presence_of :lastname, :message => I18n::t(:message_1, :scope => [:txt, :model, :candidate])
  validates_presence_of :birth_at, :message => I18n::t(:message_2, :scope => [:txt, :model, :candidate])
  validates_presence_of :email, :message => I18n::t(:message_3, :scope => [:txt, :model, :candidate])
  validates_presence_of :street, :message => I18n::t(:message_4, :scope => [:txt, :model, :candidate])
  validates_presence_of :city, :message => I18n::t(:message_5, :scope => [:txt, :model, :candidate])
  validates_presence_of :zip, :message => I18n::t(:message_6, :scope => [:txt, :model, :candidate])
  validates_presence_of :state, :message => I18n::t(:message_7, :scope => [:txt, :model, :candidate])
  validates_presence_of :university, :message => I18n::t(:message_8, :scope => [:txt, :model, :candidate])
  validates_presence_of :faculty, :message => I18n::t(:message_9, :scope => [:txt, :model, :candidate])
  validates_presence_of :studied_branch, :message => I18n::t(:message_10, :scope => [:txt, :model, :candidate])
  validates_presence_of :birth_number, :message => I18n::t(:message_11, :scope => [:txt, :model, :candidate])
  validates_presence_of :number, :message => I18n::t(:message_12, :scope => [:txt, :model, :candidate])
  validates_format_of :email, :with => /^\s*([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\s*$/i, 
    :on => :create, :message => I18n::t(:message_13, :scope => [:txt, :model, :candidate])

  # validates if languages are not same
  def validate
    errors.add_to_base(I18n::t(:message_19, :scope => [:txt, :model, :candidate])) if language1_id == language2_id
    errors.add_to_base(I18n::t(:message_20, :scope => [:txt, :model, :candidate])) if
    !finished? && invited?
    errors.add_to_base(I18n::t(:message_21, :scope => [:txt, :model, :candidate])) if
    !invited? && admited?
    errors.add_to_base(I18n::t(:message_22, :scope => [:txt, :model, :candidate])) if
    !admited? && enrolled?
  end

  def validate_on_create
    if state == "Česká republika"
      if birth_number.to_i.remainder(11) != 0
        errors.add(:birth_number, I18n::t(:message_23, :scope => [:txt, :model, :candidate]))
      end
    end
  end

  def validate_on_update
    if state == "Česká republika"
      if birth_number.to_i.remainder(11) != 0
        errors.add(:birth_number, I18n::t(:message_24, :scope => [:txt, :model, :candidate]))
      end
    end
  end

  # returns candidate's hash
  def hash
    str = "%s%i%s" % [self.lastname.first, self.id, self.firstname.first]
    return '#' + str.hash.abs.to_s
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
  def enroll!(student_id, login_name, time)
    self.update_attribute('enrolled_on', Time.now)
    return new_student(student_id, login_name, time)
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
  def new_student(enrolled_on)
    student = Student.new
    student.firstname = self.firstname
    student.lastname = self.lastname
    student.birth_on = self.birth_on
    student.birth_number = self.birth_number
    student.state = self.state
    student.birth_place = self.birth_at
    student.title_before = self.title_before
    student.title_after = self.title_after
    index = Index.new
    index.department = self.department
    index.coridor = self.coridor
    index.tutor = self.tutor
    index.study = self.study
    index.student = student
    index.enrolled_on = enrolled_on
    index.save_with_validation(false)
    create_address(student.id)
    create_postal_address(student.id) if self.postal_city
    student.email = self.email
    student.phone = self.phone if self.phone
    student.save
    return student
  end

  def admitting_faculty
    coridor.faculty
  end

  # prepares conditions for paginate functions
  def self.prepare_conditions(options, faculty, user)
    if user.has_role?('vicerector')
      conditions = ["coridor_id in (?) AND finished_on IS NOT NULL",
                    Coridor.find(:all)]
    else
      conditions = ["coridor_id in (?) AND finished_on IS NOT NULL",
                    faculty.coridors]
    end
    conditions.first << filter_conditions(options['filter'])
    if options['coridor']
       conditions.first << " AND coridor_id = #{options['coridor']}"
    end
    return conditions
  end

  # returns all candidates by filter
  def self.find_all_finished(options, faculty)
    conditions = ["coridor_id in (?) AND finished_on IS NOT NULL", 
                  faculty.coridors]
    conditions.first << filter_conditions(options['filter'])
    if options['coridor']
      conditions.first << " AND coridor_id = ?"
      conditions << options['coridor']
    end
    Candidate.find(:all, :order => options['category'],
      :conditions => conditions)
  end

  def self.find_all_finished_by_session_category(options, faculty, category, user)
    if user.has_role?('vicerector')
      conditions = ["coridor_id in (?) AND finished_on IS NOT NULL",
                    Coridor.find(:all)]      
    else
      conditions = ["coridor_id in (?) AND finished_on IS NOT NULL", 
                    faculty.coridors]
    end
    conditions.first << filter_conditions(options['filter'])
    if options['coridor']
      conditions.first << " AND coridor_id = ?"
      conditions << options['coridor']
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
    when 'ready': ' AND ready_on IS NOT NULL AND
      invited_on IS NULL'
    when 'invited': ' AND invited_on IS NOT NULL AND
      admited_on IS NULL'
    when 'admited': ' AND admited_on IS NOT NULL AND
      enrolled_on IS NULL'
    when 'enrolled': ' AND enrolled_on IS NOT NULL'
    when nil: ''
    end
  end

  def present_study?
    study_id == 1
  end

end
