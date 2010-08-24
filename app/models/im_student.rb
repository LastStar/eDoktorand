# Every student should have one ImStudent created by migration.
# On every update of student its ImStudent should be updated also.
# On every create of student ImStudent should be created.
# Once a night Eventlog would be created for every updated/created ImStudent
class ImStudent < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :student

  before_save :get_student_attributes
  after_create :create_logevent
  after_update :update_logevent

  # creates update logevent
  def update_logevent
    Logevent.create(:table_key => "id=#{self.id}",
                    :status => 'N',
                    :event_type => 6,
                    :event_time => Time.now,
                    :perpetrator => "IDM",
                    :table_name => self.class.table_name)
  end

  # creates log event
  def create_logevent
    Logevent.create(:table_key => "id=#{self.id}",
                    :status => 'N',
                    :event_type => 5,
                    :event_time => Time.now,
                    :perpetrator => "IDM",
                    :table_name => self.class.table_name)
  end

  # gets attributtes from student relation
  def get_student_attributes
    student.reload
    self.uic = student.uic
    self.lastname = student.lastname
    self.firstname = student.firstname
    self.birthname = student.birthname
    self.birth_number = student.birth_number
    self.sex = student.sex
    self.created_on = student.created_on
    self.title_before = student.title_before.label if student.title_before
    self.title_after = student.title_after.label if student.title_after
    self.birth_place = student.birth_place
    self.birth_on = student.birth_on
    self.email = student.email
    self.phone = student.phone
    self.citizenship = student.citizenship
    self.qualif_citizenship = Country.qualified_code(student.citizenship)
    self.permaddress_street = student.street
    self.permaddress_housenr = student.desc_number
    self.permaddress_housenrguid = student.orient_number
    self.permaddress_city = student.city
    self.permaddress_zip = student.zip
    self.contact_street = student.postal_street
    self.contact_housenr = student.postal_desc_number
    self.contact_housenrguid = student.postal_orient_number
    self.contact_city = student.postal_city
    self.contact_zip = student.postal_zip
    self.marital_status = student.marital_status
    # TODO isn't it here only cause of specing?
    if student.index.try(:account_number)
      self.bank_branch = student.index.account_number_prefix
      self.bank_account = student.index.account_number
      self.bank_code = student.index.account_bank_number
    end
    return self
  end
end
