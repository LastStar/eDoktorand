class Exam < ActiveRecord::Base
 belongs_to :index
 belongs_to :subject
 belongs_to :creator, :class_name => "Person", :foreign_key => "created_by"
 belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
 belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
 validates_presence_of :index
 validates_presence_of :subject
 validates_presence_of :first_examinator
 validates_presence_of :creator
end
