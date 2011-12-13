class AdmissionTerm < ExamTerm

  belongs_to :specialization
  validates_presence_of :specialization_id, :message => I18n::t(:wrong_time_format, :scope => [:model, :term])

  def self.find_for(user)
    if user.has_one_of_roles?(['vicerector', 'university_secretary'])
      conditions = ["specialization_id in (?)", Specialization.find(:all)]
    else
      conditions = ["specialization_id in (?)", Specialization.find_for(user)]
    end
    find(:all, :conditions => conditions)
  end
end
