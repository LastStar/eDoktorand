class AdmissionTerm < ExamTerm
  
  belongs_to :specialization
  validates_presence_of :specialization_id, :message => I18n::t(:message_0, :scope => [:txt, :model, :term])

  def self.find_for(user)
    find(:all, :conditions => ['specialization_id in (?)', Specialization.find_for(user)])
  end
end
