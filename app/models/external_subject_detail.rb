class ExternalSubjectDetail < ActiveRecord::Base
  untranslate_all
  belongs_to :external_subject, :class_name => "ExternalSubject"
  validates_presence_of :university
end
