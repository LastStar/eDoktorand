class Candidate < ActiveRecord::Base
  belongs_to :coridor
  belongs_to :department
  belongs_to :study

  validates_presence_of :name, :message => "Jm�no nesm� b�t pr�zdn�"
  validates_presence_of :last_name, :message => "P��jmen� nesm� b�t pr�zdn�"
  validates_presence_of :birth_at, :message => "M�sto narozen� nesm� b�t pr�zdn�"
  validates_presence_of :email, :message => "Email nesm� b�t pr�zdn�"
  validates_presence_of :street, :message => "Ulice bydli�t� nesm� b�t pr�zdn�"
  validates_presence_of :city, :message => "Obec bydli�t� nesm� b�t pr�zdn�"
  validates_presence_of :zip, :message => "PS� bydli�t� nesm� b�t pr�zdn�"
  validates_presence_of :state, :message => "St�tn� p��slu�nost nesm� b�t pr�zdn�"
  validates_presence_of :university, :message => "Univerzita nesm� b�t pr�zdn�"
  validates_presence_of :faculty, :message => "Fakulta nesm� b�t pr�zdn�"
  validates_presence_of :studied_branch, :message => "Obor nesm� b�t pr�zdn�"
  validates_presence_of :birth_number, :message => "Rodn� ��slo nesm� b�t pr�zdn�"
  validates_presence_of :title, :message => "Titul nesm� b�t pr�zdn�"
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, 
  :on => :create, :message => "Email nem� spr�vn� form�t"
  # validates_format_of :birth_number, :with => /^[\d]{6}\/?[\d]{4}/, 
  # :on => :create, :message => "Rodn� ��slo nem� spr�vn� form�t"

  # validates if languages are not same
  def validate
    errors.add_to_base("Jazyky mus� b�t rozd�ln�") if language1 == language2
  end
  # finishes candidate
  def finish!
    self.finished_on = Time.now
  end
end
