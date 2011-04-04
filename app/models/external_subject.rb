class ExternalSubject < Subject
  
  has_one :external_subject_detail, :dependent => :destroy

  def label
    "%s - %s (%s)" % [self[:label],self.label_en, self.external_subject_detail.university]
  end
end
