class ExternalSubjectDetail < ActiveRecord::Base
  
  belongs_to :external_subject
  validates_presence_of :university, :message => I18n::t(:university_must_be_present, :scope => [:txt, :model, :detail])
end
