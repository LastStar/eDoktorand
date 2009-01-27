class AdmissionTerm < ExamTerm
  untranslate_all
  belongs_to :coridor
  validates_presence_of :coridor_id, :message => t(:message_0, :scope => [:txt, :model, :term])

  def self.find_for(user)
    find(:all, :conditions => ['coridor_id in (?)', Coridor.find_for(user)])
  end
end
