class Student < Person
  has_one :index
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

  #returns display name for printing
  def display_name
    "#{lastname} #{firstname}"
  end

  # retunrs account for printing
  def account
    if scholarship_supervised_date
      if account_number_prefix
        "#{s.index.account_number_prefix}-#{s.index.account_number}/#{s.index.account_bank_number}"
      else
        "#{s.index.account_number}/#{s.index.account_bank_number}"
      end
    end
  end

  # colects students
  # got one option :study_plans
  def self.colect_unfinished(options)
    if options[:study_plans]
      students = []
      options[:study_plans].each do |sp|
        students << sp.index.student if !sp.index.finished?
      end
    end
    students
  end
end 
