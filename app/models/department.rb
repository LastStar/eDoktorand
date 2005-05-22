# this is stub for admit form. In application should be changed to unit
class Department < ActiveRecord::Base
  has_many :candidates
	has_many :students
  belongs_to :faculty
end
