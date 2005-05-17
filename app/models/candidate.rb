class Candidate < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :department
  belongs_to :study
  belongs_to :student
  belongs_to :title_before, :class_name => 'Title', :foreign_key => 'title_before_id'
  belongs_to :title_after, :class_name => 'Title', :foreign_key => 'title_after_id'
  validates_presence_of :firstname, :message => "Jméno nesmí být prazdné"
  validates_presence_of :lastname, :message => "Příjmení nesmí být prazdné"
  validates_presence_of :birth_at, :message => "Místo narození nesmí být prazdné"
  validates_presence_of :email, :message => "Email nesmí být prazdný"
  validates_presence_of :street, :message => "Ulice bydliště nesmí být prazdná"
  validates_presence_of :city, :message => "Obec bydliště nesmí být prazdná"
  validates_presence_of :zip, :message => "PSČ bydliště nesmí být prazdné"
  validates_presence_of :state, :message => "Státní příslušnost nesmí být prazdná"
  validates_presence_of :university, :message => "Univerzita nesmí být prazdná"
  validates_presence_of :faculty, :message => "Fakulta nesmí být prazdná"
  validates_presence_of :studied_branch, :message => "Obor nesmí být prazdný"
  validates_presence_of :birth_number, :message => "Rodné číslo nesmí být prazdné"
  #validates_presence_of :title_before, :message => "Titul před jménem nesmí být prázdný"
  validates_presence_of :number, :message => "Čislo popisné nesmí být prazdné"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, 
  :on => :create, :message => "Email nemá správný formát"
  validates_uniqueness_of :birth_number, :message => "Vámi zadané rodné číslo již v systému existuje. Prosím kontaktujte <a href='mailto:pepe@gravastar.cz'>správce systému</a>."
  # validates if languages are not same
  def validate
    errors.add_to_base("Jazyky musí být rozdílné") if language1 == language2
  end
  # finishes candidate
  def finish!
    self.finished_on = Time.now
    self.save
  end
  # returns name for displaying
  def display_name  
		arr = []
		arr << self.title_before.name if self.title_before
    arr = [ self.firstname, self.lastname]
    arr <<  self.title_after.name if self.title_after
    return arr.join(' ')
  end
  # returns address for displaying
  def address
    return [[self.street, self.number.to_s].join(' '), self.city, self.zip].join(', ')
  end
  # returns postal address for displaying
  def postal_address
    return [[self.postal_street, self.postal_number.to_s].join(' '), self.postal_city, self.postal_zip].join(', ')
  end
  # invites candidate to entrance exam
  def invite!
    self.invited_on = Time.now
    self.save
  end
  # checks if candidate is allready invited 
  def invited?
    return !self.invited_on.nil?
  end
  # admits candidate to study and returns new student based on 
  # candidates details. 
  def admit!
    self.admited_on = Time.now
    student = Student.new
    student.birth_number = self.birth_number
    student.birth_on = self.birth_on
    student.birth_at = self.birth_at
    student.title_before = self.title_before
    student.title_after = self.title_after
    student.state = self.state
    student.firstname, student.lastname = self.firstname, self.lastname
    student.save
    create_address(student.id)
    if self.postal_city
      create_postal_address(student.id)
    end
    student.email = self.contact_email
    student.phone = self.contact_phone if self.phone
    self.student = student
    self.save
  end
  # checks if candidate is allready admited
  def admited?
    return !self.admited_on.nil?
  end
  # sets candidate ready for admition
  def ready!
    self.ready_on = Time.now
    self.save
  end
  # checks if student is ready
  def ready?
    !self.ready_on.nil?
  end
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
