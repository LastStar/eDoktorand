class ExternalSubject < Subject
  untranslate_all
  has_one :external_subject_detail

  def label
    "%s (%s)" % [self[:label], self.external_subject_detail.university]
  end
end
