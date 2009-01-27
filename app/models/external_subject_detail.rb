class ExternalSubjectDetail < ActiveRecord::Base
  
  belongs_to :external_subject
  validates_presence_of :university, :message => I18n::t(:message_0, :scope => [:txt, :model, :detail])
end
