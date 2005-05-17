class Coridor < ActiveRecord::Base
  belongs_to :faculty
  has_many :candidates
	has_one :exam_term
end
