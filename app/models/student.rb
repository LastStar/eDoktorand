class Student < Person
  has_one :index, :dependent => :destroy
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

  # retunrs account for printing
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
end 
