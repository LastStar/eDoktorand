class AdmissionTerm < ExamTerm
  untranslate_all
  belongs_to :coridor
  validates_presence_of :coridor_id, :message => _("Term must has assigned corridor")

  def self.find_for(user)
    find(:all, :conditions => ['coridor_id in (?)', Coridor.find_for(user)])
  end
end
