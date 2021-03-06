# Every student should have one ImStudent created by migration.
# On every update of student its ImStudent should be updated also.
# On every create of student ImStudent should be created.
# Once a night Eventlog would be created for every updated/created ImStudent
class ImStudent < ActiveRecord::Base
  belongs_to :student

  validates_presence_of :student

  # gets attributes from student relation
  def get_student_attributes
    old_loc = I18n.locale
    I18n.locale = :cs
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
    I18n.locale = old_loc
    return self
  end
end
