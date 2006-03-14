class Candidate < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :department
  belongs_to :study
  belongs_to :student
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key => 'title_after_id'
  belongs_to :exam_term
  belongs_to :tutor
  has_one :admittance
  belongs_to :language1, :class_name => 'Subject', :foreign_key => 
    'language1_id'
  belongs_to :language2, :class_name => 'Subject', :foreign_key => 
    'language2_id' 
  validates_presence_of :firstname, :message => _("firstname can not be empty")
  validates_presence_of :lastname, :message => _("lastname can not be empty")
  validates_presence_of :birth_at, :message => _("birth place cannot be empty")
  validates_presence_of :email, :message => _("email cannot be empty")
  validates_presence_of :street, :message => _("street cannot be empty")
  validates_presence_of :city, :message => _("city cannot be empty")
  validates_presence_of :zip, :message => _("zip cannot be empty")
  validates_presence_of :state, :message => _("state cannot be empty")
  validates_presence_of :university, :message => _("university cannot be empty")
  validates_presence_of :faculty, :message => _("faculty cannot be empty")
  validates_presence_of :studied_branch, :message => _("corridor cannot be empty")
  validates_presence_of :birth_number, :message => _("birth number cannot be empty")
  validates_presence_of :number, :message => _("street number cannot be empty")
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, 
    :on => :create, :message => _("email does not have right format")
  # validates if languages are not same
  def validate
    errors.add_to_base(_("languages have to be different")) if language1_id == language2_id
    errors.add_to_base(_("candidate must be finished before invitation")) if
    !finished? && invited?
    errors.add_to_base(_("candidate must be invited before admittance")) if
    !invited? && admited?
    errors.add_to_base(_("candidate must be admited before enrollment")) if
    !admited? && enrolled?
  end

  # hooks: create student
  def before_update
    if self.enrolled? && self.valid? && !student
      self.student = create_student
    end
  end

  # finishes candidate
  def finish!
    self.finished_on = Time.now
    self.save
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
  def enroll!
    self.update_attribute('enrolled_on', Time.now)
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

  # checks if student is reject
  def rejected?
    !self.rejected_on.nil?
  end

  # TODO redone with aggregations
  # returns email like contact object
  def contact_email
    return Contact.new do |c|
      c.name = self.email
      c.contact_type_id = 1
    end
  end

  # returns phone like contact object
  def contact_phone
    return Contact.new do |c|
      c.name = self.phone
      c.contact_type_id = 2
    end
  end

  # returns new address with attributes set by self 
  def create_address(id)
    add = Address.new {|a|
      a.student_id = id
      a.street = self.street
      a.desc_number = self.number
      a.city = self.city
      a.zip = self.zip
      a.type = AddressType.find(1)
    }
    add.save
  end

  # returns new postal address with attributes set by self
  def create_postal_address(id)
    if self.postal_city
      add = Address.new {|a|
        a.student_id = id
        a.street = self.postal_street
        a.desc_number = self.postal_number
        a.city = self.postal_city
        a.zip = self.postal_zip
        a.type = AddressType.find(2)
      }
      add.save
    end
  end

  # creates student 
  def create_student
    # convert candidate to (student+index)
    student = Student.new
    student.firstname = self.firstname
    student.lastname = self.lastname
    student.birth_on = self.birth_on
    student.birth_number = self.birth_number
    student.state = self.state
    student.birth_place = self.birth_at
    student.title_before = self.title_before
    student.title_after = self.title_after
    student.save
    index = Index.new
    index.student = student
    index.department = self.department
    index.coridor = self.coridor
    index.tutor = self.tutor
    index.study = self.study
    index.save
    create_address(student.id)
    create_postal_address(student.id) if self.postal_city
    student.email = self.contact_email
    student.phone = self.contact_phone if self.phone 		
    return student
  end

  # prepares conditions for paginate functions
  def self.prepare_conditions(options, faculty)
    conditions = ["department_id in (?)", faculty.departments_ids]
    conditions.first << filter_conditions(options['filter'])
    if options['coridor']
       conditions.first << " AND coridor_id = #{options['coridor']}"
     end
     return conditions
  end

  # returns all candidates by filter
  def self.find_all_finished(options, faculty)
    conditions = ["department_id in (?)", faculty.departments_ids]
    conditions.first << filter_conditions(options['filter'])
    if options['coridor']
      conditions << " AND coridor_id = #{options['coridor']}" 
    end
	  Candidate.find(:all, :order => options['category'],
      :conditions => conditions)
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
end
