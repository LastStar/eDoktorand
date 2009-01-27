class ExternalSubjectDetail < ActiveRecord::Base
  untranslate_all
  belongs_to :external_subject
  validates_presence_of :university, :message => Nt(:message_0, :scope => [:txt, :model, :detail])
end
