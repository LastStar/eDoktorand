class Student < Examinator

  has_one :index, :dependent => :destroy, :order => 'finished_on asc, created_on desc'
  has_one :candidate
  has_and_belongs_to_many :probation_terms
  has_one :im_student

  after_save :update_im_student

  # updates ImStudent with new attributes
  def update_im_student
    prepare_im_student unless im_student
    im_student.get_student_attributes
    im_student.save
  end

  # prepares ImStudent if there is no one
  def prepare_im_student
    build_im_student unless im_student
    im_student.student = self
    im_student.get_student_attributes
  end

  #TODO delegate
  # returns faculty on which student is
  def faculty
    index.faculty
  end

  #returns display name for printing
  def display_name
    disp_name = "#{lastname} #{firstname}"
    disp_name << (title_before ? ", %s" % title_before.label : '')
    disp_name << (title_after ? " %s" % title_after.label : '')
    return disp_name
  end

  #TODO delegate
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

  #TODO delegate
  def specialization
    index.specialization
  end

  def address_or_create
    return address if address
    Address.create_habitat_for(id)
  end

  #TODO delegate
  def has_study_plan?
    !index.study_plan.nil?
  end

  #TODO delegate
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
    !city.nil? && !city.empty?
  end

  def prepared_for_claim?
    has_account? && has_address?
  end

  def <=>(other)
    display_name <=> other.display_name
  end

  #TODO delegate
  def department
    index.department
  end

  # returns struct for web services
  def to_service_struct
    service_struct = StudentHash.new
    service_struct.student_id = self.id
    service_struct.uic = self.uic
    service_struct.firstname = self.firstname
    service_struct.lastname = self.lastname
    service_struct.birthname = self.birthname
    service_struct.birth_on = self.birth_on
    service_struct.citizenship = self.citizenship
    service_struct.birth_number = self.birth_number
    service_struct.birth_place = self.birth_place
    service_struct.sex = self.sex
    service_struct.created_on = self.created_on
    service_struct.updated_on = self.updated_on
    service_struct.title_before = self.title_before ? self.title_before.label : ''
    service_struct.title_after = self.title_after ? self.title_after.label : ''
    service_struct.email = self.email ? self.email.name : ''
    service_struct.phone = self.phone ? self.phone.name : ''
    service_struct.street = self.address.street ? self.address.street : ''
    service_struct.desc_number = self.address.desc_number ? self.address.desc_number : ''
    service_struct.orient_number = self.address.orient_number ? self.address.orient_number : ''
    service_struct.city = self.address.city ? self.address.city : ''
    service_struct.zip = self.address.zip ? self.address.zip : ''
    service_struct.state = self.address.state ? self.address.state : ''
    return service_struct
  end

  # updates itself from StudentHash
  def update_with_hash(student_hash)
    raise 'uic needed' unless uic
    self.uic = student_hash.uic
    self.firstname = student_hash.firstname if student_hash.firstname
    self.lastname = student_hash.lastname if student_hash.lastname
    self.birthname = student_hash.birthname if student_hash.birthname
    self.birth_on = student_hash.birth_on if student_hash.birth_on
    self.citizenship = student_hash.citizenship if student_hash.citizenship
    self.birth_number = student_hash.birth_number if student_hash.birth_number
    self.birth_place = student_hash.birth_place if student_hash.birth_place
    self.sex = student_hash.sex if student_hash.sex
    if student_hash.title_before &&
      title = Title.find_by_label_and_prefix(student_hash.title_before, 1)
      self.title_before = title
    end
    if student_hash.title_after &&
      title = Title.find_by_label_and_prefix(student_hash.title_after, 0)
      self.title_after = title
    end
    if student_hash.email
      if self.email
        self.email.update_attribute(:name, student_hash.email)
      else
        self.email = Contact.new(:name => student_hash.email,
                                 :contact_type_id => 1)
      end
    end
    if student_hash.phone
      if self.phone
        self.phone.update_attribute(:name, student_hash.phone)
      else
        self.phone = Contact.new(:name => student_hash.email,
                                 :contact_type_id => 2)
      end
    end
    self.save
  end

end
