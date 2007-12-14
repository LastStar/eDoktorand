class Student < Examinator
  untranslate_all
  has_one :index, :dependent => :destroy, :order => 'created_on desc'
  has_one :address, :conditions => 'address_type_id = 1', 
          :dependent => :destroy
  has_one :postal_address, :class_name => 'Address', 
          :conditions => 'address_type_id = 2', :dependent => :destroy
  has_one :candidate
  has_and_belongs_to_many :probation_terms

  N_('to')
  N_('Birth date')
  N_('Year')
  N_('Enrolled on')
  N_('with note')
  N_('date finished')
  N_('Pass final exam')
  N_('Pass defense')
  N_('Switch study')
  N_('finish to')
  N_('switch study to')
  N_('pass final exam to')
  N_('pass final exam')
  N_('pass defense')
  N_('pass defense to')
  
  
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

  def claim_accommodation_scholarship!
    update_attribute(:scholarship_claimed_at, Time.now)
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

  def scholarship_claimed?
    !scholarship_claimed_at.nil?
  end

  def <=>(other)
    display_name <=> other.display_name
  end

  def department
    index.department
  end

  def to_wsdl_hash
    struct =  {
      'uic' => self.uic,
      'student_id' => self.id,
      'firstname' => self.firstname,
      'lastname' => self.lastname,
      'birthname' => self.birthname,
      'birth-on' => self.birth_on,
      'citizenship' => self.citizenship,
      'birth-number' => self.birth_number,
      'birth-place' => self.birth_place,
      'sex' => self.sex,
      'created-on' => self.created_on,
      'update-on' => self.updated_on,
      'adress' => {
        'street' => self.address.street,
        'desc-number' => self.address.desc_number,
        'orient-number' => self.address.orient_number,
        'city' => self.address.city,
        'zip' => self.address.zip,
        'state' => self.address.state
      }
    }
    struct['title-before'] = self.title_before ? self.title_before.name : ''
    struct['title-after'] = self.title_after ? self.title_after.name : ''
    struct['email'] = self.email ? self.email.name : ''
    struct['phone'] = self.phone ? self.phone.name : ''
    return struct
  end
end 
