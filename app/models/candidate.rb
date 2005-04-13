# fixme name => fistname, last_name => lastname
class Candidate < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :department
  belongs_to :study

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
  validates_presence_of :title, :message => "Titul nesmí být prazdný"
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
    dn = self.firstname + " " + self.lastname
    dn = self.title + ' ' + dn unless self.title.nil?
  end
  # returns address for displaying
  def address
    return [[self.street, self.number.to_s].join(' '), self.city, self.zip].join (', ')
  end
  # returns postal address for displaying
  def postal_address
    return [[self.postal_street, self.postal_number.to_s].join(' '), self.postal_city, self.postal_zip].join (', ')
  end
  # admits candidate to study and returns new student based on 
  # candidates details. 
  def admit!
    self.admited_on = Time.now
  end
end
