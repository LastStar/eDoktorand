class FinalExamTerm < ExamTerm
  untranslate_all
  belongs_to :index
  validates_presence_of :index_id, :message => _("Final exam term have to belong to student")
end
