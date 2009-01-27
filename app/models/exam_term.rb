class ExamTerm < ActiveRecord::Base
  untranslate_all
  belongs_to :chairman, :class_name => 'Tutor', :foreign_key => 'chairman_id'
        Nt(:message_0, :scope => [:txt, :model, :term])
	validates_presence_of :room, :message => t(:message_1, :scope => [:txt, :model, :term])
	validates_presence_of :chairman_id, :message => t(:message_2, :scope => [:txt, :model, :term])
	validates_presence_of :start_time, :message => t(:message_3, :scope => [:txt, :model, :term])
	validates_presence_of :date, :message => t(:message_4, :scope => [:txt, :model, :term])
	validates_presence_of :first_examinator, :message => t(:message_5, :scope => [:txt, :model, :term])
	validates_presence_of :second_examinator, :message => t(:message_6, :scope => [:txt, :model, :term])

end
