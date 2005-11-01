class Exam < ActiveRecord::Base
 belongs_to :index
 belongs_to :subject
 belongs_to :created_by, :class_name => "Person", :foreign_key => "created_by_id"
 belongs_to :first_examinator, :class_name => "Person", :foreign_key => "first_examinator_id"
 belongs_to :second_examinator, :class_name => "Person", :foreign_key => "second_examinator_id"
 validates_presence_of :index
 validates_presence_of :subject
 # returns true if result is pass
 def passed?
   return true if result == 1
 end
end
