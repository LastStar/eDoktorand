class ExternalSubjectDetail < ActiveRecord::Base
  belongs_to :external_subject, :class_name => "ExternalSubject", :foreign_key => "subject_id" 
  validates_presence_of :subject_id, :message => "Musí být vyplnen odkaz na
  predmet"
  validates_presence_of :university, :message => "Musí být vyplnen údaj o
  univerzite"
end
