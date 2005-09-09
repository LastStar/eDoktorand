# this is stub for admit form. In application should be changed to unit
class Department < ActiveRecord::Base
  has_many :candidates
	has_many :students
  has_many :indices
  has_one :leadership
  belongs_to :faculty
  has_and_belongs_to_many :subjects
end
