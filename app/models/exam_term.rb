class ExamTerm < ActiveRecord::Base
  
  belongs_to :chairman, :class_name => 'Tutor', :foreign_key => 'chairman_id'
	validates_presence_of :room, :message => I18n::t(:message_1, :scope => [:txt, :model, :term])
	validates_presence_of :chairman_id, :message => I18n::t(:message_2, :scope => [:txt, :model, :term])
	validates_presence_of :start_time, :message => I18n::t(:message_3, :scope => [:txt, :model, :term])
	validates_presence_of :date, :message => I18n::t(:message_4, :scope => [:txt, :model, :term])
	validates_presence_of :first_examinator, :message => I18n::t(:message_5, :scope => [:txt, :model, :term])
	validates_presence_of :second_examinator, :message => I18n::t(:message_6, :scope => [:txt, :model, :term])

end
