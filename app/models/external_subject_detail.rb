class ExternalSubjectDetail < ActiveRecord::Base
  belongs_to :external_subject, :class_name => "ExternalSubject"
  validates_presence_of :university
end
