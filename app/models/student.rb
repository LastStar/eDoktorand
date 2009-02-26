class Student < Examinator
  
  has_one :index, :dependent => :destroy, :order => 'created_on desc'
  has_one :address, :conditions => 'address_type_id = 1', 
          :dependent => :destroy
  has_one :postal_address, :class_name => 'Address', 
          :conditions => 'address_type_id = 2', :dependent => :destroy
  has_one :candidate
  has_and_belongs_to_many :probation_terms

  # returns faculty on which student is
  def faculty
    index.faculty
  end

  #returns display name for printing
  def display_name
    "#{lastname} #{firstname}"
  end

  # returns account for printing
  def account
    i = self.index
    if i.account_number_prefix && i.account_number_prefix != ""
      "#{self.index.account_number_prefix}-#{self.index.account_number}/#{self.index.account_bank_number}"
    elsif i.account_number && i.account_number != ""
      "#{self.index.account_number}/#{self.index.account_bank_number}"
    else
      ''
    end
  end

  def coridor
    index.coridor
  end

  def address_or_create
    return address if address
    Address.create_habitat_for(id)
  end

  def has_study_plan?
    !index.study_plan.nil?
  end

  def study_plan
    index.study_plan
  end

  def has_enrolled?(subject)
    subject = subject.id if subject.is_a? Subject
    !ProbationTerm.find(:all, 
                       :conditions => ['subject_id = ? and date > ?',
                                        subject, Date.today]).detect do |pt|
      pt.students.include? self
    end.nil?
  end

  def self.find_to_enroll(probation_term, option)
    students = PlanSubject.find_unfinished_by_subject(probation_term.subject.id,
                                            :students => true)
    students.reject! do |student|
      student.has_enrolled?(probation_term.subject)
    end
    if option == :sort
      students.sort! {|x, y| x.lastname <=> y.lastname}
    end
  end

  def has_account?
    !index.account_number.nil?
  end

  def has_address?
    !address.nil?
  end

  def prepared_for_claim?
    has_account? && has_address? 
  end

  def <=>(other)
    display_name <=> other.display_name
  end

  def department
    index.department
  end

  # returns struct for web services
  def to_service_struct
    wsdl_struct = StudentHash.new

    wsdl_struct.uic = self.uic
    wsdl_struct.student_id = self.id
    wsdl_struct.firstname = self.firstname
    wsdl_struct.lastname = self.lastname
    wsdl_struct.birthname = self.birthname
    wsdl_struct.birth_on = self.birth_on
    wsdl_struct.citizenship = self.citizenship
    wsdl_struct.birth_number = self.birth_number
    wsdl_struct.birth_place = self.birth_place
    wsdl_struct.sex = self.sex
    wsdl_struct.created_on = self.created_on
    wsdl_struct.updated_on = self.updated_on
    wsdl_struct.title_before = self.title_before ? self.title_before.name : ''
    wsdl_struct.title_after = self.title_after ? self.title_after.name : ''
    wsdl_struct.email = self.email ? self.email.name : ''
    wsdl_struct.phone = self.phone ? self.phone.name : ''

    return wsdl_struct
  end
end 
