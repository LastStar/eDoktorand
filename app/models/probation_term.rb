class ProbationTerm < ActiveRecord::Base
 belongs_to :subject
 belongs_to :creator, :class_name => "Person", :foreign_key => "created_by"
 belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
 belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
 has_and_belongs_to_many :students
 validates_presence_of :subject
 validates_presence_of :creator
end
