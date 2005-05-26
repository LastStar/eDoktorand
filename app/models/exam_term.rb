class ExamTerm < ActiveRecord::Base
	belongs_to :coridor
	belongs_to :chairman, :class_name => 'Tutor', :foreign_key => 'chairman_id'
	validates_presence_of :coridor_id, :message => 'Termín musí mít přidělený koridor'
	validates_presence_of :room, :message => 'Termín musí mít přidělenou místnost'
	validates_presence_of :chairman_id, :message => 'Termín musí mít přiděleného předsedu'
	validates_presence_of :start_time, :message => 'Termín musí mít přidělený čas začátku'
	validates_presence_of :date, :message => 'Termín musí mít přidělený datum začátku'
	validates_presence_of :first_examinator, :message => 'Termín musí mít přiděleného prvního zkoušejícího'
	validates_presence_of :second_examinator, :message => 'Termín musí mít přiděleného druhého zkoušejícího'
#	validates_uniqueness_of :coridor_id, :message => 'Pro tento koridor termín již existuje'
end
