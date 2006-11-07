class ExamTerm < ActiveRecord::Base
        untranslate_all
        belongs_to :chairman, :class_name => 'Tutor', :foreign_key => 'chairman_id'

	validates_presence_of :room, :message => _("Term must has assigned room")
	validates_presence_of :chairman_id, :message => _("Term must has assigned chairman")
	validates_presence_of :start_time, :message => _("Term must has assigned time of begining")
	validates_presence_of :date, :message => _("Term must has assigned date of begining")
	validates_presence_of :first_examinator, :message => _("Term must has assigned first examiner")
	validates_presence_of :second_examinator, :message => _("Term must has assigned second examiner")
end
