class Candidate < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :department
  belongs_to :study

  validates_presence_of :name, :message => "Jméno nesmí být prázdné"
  validates_presence_of :last_name, :message => "Pøíjmení nesmí být prázdné"
  validates_presence_of :birth_at, :message => "Místo narození nesmí být prázdné"
  validates_presence_of :email, :message => "Email nesmí být prázdný"
  validates_presence_of :street, :message => "Ulice bydli¹tì nesmí být prázdná"
  validates_presence_of :city, :message => "Obec bydli¹tì nesmí být prázdná"
  validates_presence_of :zip, :message => "PSÈ bydli¹tì nesmí být prázdné"
  validates_presence_of :state, :message => "Státní pøíslu¹nost nesmí být prázdná"
  validates_presence_of :university, :message => "Univerzita nesmí být prázdná"
  validates_presence_of :faculty, :message => "Fakulta nesmí být prázdná"
  validates_presence_of :studied_branch, :message => "Obor nesmí být prázdný"
  validates_presence_of :birth_number, :message => "Rodné èíslo nesmí být prázdné"
  validates_presence_of :title, :message => "Titul nesmí být prázdný"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, 
  :on => :create, :message => "Email nemá správný formát"
  # validates_format_of :birth_number, :with => /^[\d]{6}\/?[\d]{4}/, 
  # :on => :create, :message => "Rodné èíslo nemá správný formát"

  # validates if languages are not same
  def validate
    errors.add_to_base("Jazyky musí být rozdílné") if language1 == language2
  end
  # finishes candidate
  def finish!
    self.finished_on = Time.now
  end
end
