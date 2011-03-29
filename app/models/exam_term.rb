class ExamTerm < ActiveRecord::Base
  
  belongs_to :chairman, :class_name => 'Tutor', :foreign_key => 'chairman_id'
	validates_presence_of :room, :message => I18n::t(:room_must_be_filled, :scope => [:txt, :model, :term])
	validates_presence_of :start_time, :message => I18n::t(:wrong_time_format, :scope => [:txt, :model, :term])
	validates_presence_of :date, :message => I18n::t(:date_must_be_present, :scope => [:txt, :model, :term])
	validates_presence_of :first_examinator, :message => I18n::t(:first_examinator_must_be_present, :scope => [:txt, :model, :term])
	validates_presence_of :second_examinator, :message => I18n::t(:second_examinator_must_be_present, :scope => [:txt, :model, :term])

  # FIXME get rid of this!
  # sets external chairman_id or chairman_name
  def detect_external_chairman(parameter)
    if parameter == "true"
      self.chairman_id = Tutor.external_chairman.id
    else
      self.chairman_name = Tutor.find(self.chairman_id).display_name
    end
  end

 end
