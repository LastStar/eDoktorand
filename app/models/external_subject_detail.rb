class ExternalSubjectDetail < ActiveRecord::Base
  belongs_to :external_subject, :class_name => "ExternalSubject", :foreign_key => "subject_id" 
  validates_presence_of :subject_id, :message => "Mus� b�t vyplnen odkaz na
  predmet"
  validates_presence_of :university, :message => "Mus� b�t vyplnen �daj o
  univerzite"
end
