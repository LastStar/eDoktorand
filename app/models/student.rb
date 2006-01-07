class Student < Person
  has_one :index, :foreign_key => 'student_id'
  has_one :address, :conditions => 'address_type_id = 1'
  has_one :postal_address, :class_name => 'Address', :conditions => 'address_type_id = 2'
  has_one :email, :class_name => 'Contact', :foreign_key => 'person_id', :conditions => 'contact_type_id = 1'
  has_one :phone, :class_name => 'Contact', :foreign_key => 'person_id', :conditions => 'contact_type_id = 2'
  has_one :candidate
  has_and_belongs_to_many :probation_terms
  # returns faculty on which student is
  def faculty
    index.department.faculty
  end
  def display_name
    "#{lastname} #{firstname}"
  end
  def account
    if scholarship_supervised_date
      if account_number_prefix
        "#{s.index.account_number_prefix}-#{s.index.account_number}/#{s.index.account_bank_number}"
      else
        "#{s.index.account_number}/#{s.index.account_bank_number}"
      end
    end
  end
end 
