class AdmissionTerm < ExamTerm
  
  belongs_to :specialization
  validates_presence_of :specialization_id, :message => I18n::t(:wrong_time_format, :scope => [:txt, :model, :term])

  def self.find_for(user)
    find(:all, :conditions => ['specialization_id in (?)', Specialization.find_for(user)])
  end
end
