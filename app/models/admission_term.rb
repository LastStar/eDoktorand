class AdmissionTerm < ExamTerm
  untranslate_all
  belongs_to :coridor
  validates_presence_of :coridor_id, :message => _("Term must has assigned corridor")
end
