class ExamTerm < ActiveRecord::Base

  belongs_to :chairman, :class_name => 'Tutor', :foreign_key => 'chairman_id'
	validates_presence_of :room, :message => I18n::t(:room_must_be_filled, :scope => [:model, :term])
	validates_presence_of :start_time, :message => I18n::t(:wrong_time_format, :scope => [:model, :term])
	validates_presence_of :date, :message => I18n::t(:date_must_be_present, :scope => [:model, :term])
	validates_presence_of :first_examinator, :message => I18n::t(:first_examinator_must_be_present, :scope => [:model, :term])
	validates_presence_of :second_examinator, :message => I18n::t(:second_examinator_must_be_present, :scope => [:model, :term])

  # FIXME get rid of this!
  # sets external chairman_id or chairman_name
  def detect_external_chairman(parameter)
    if parameter == "true"
      self.chairman_id = Tutor.external_chairman.id
    else
      self.chairman_name = Tutor.find(self.chairman_id).display_name
    end
  end

  def has_external_or_empty_chairman?
    self.chairman_id == Tutor.external_chairman.id || self.chairman_id.nil?
  end

  def chairman_display_name
    return chairman_name if chairman_name.present?
    return chairman.display_name
  end
 end
