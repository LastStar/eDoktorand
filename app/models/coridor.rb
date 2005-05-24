class Coridor < ActiveRecord::Base
  belongs_to :faculty
  has_many :candidates
  has_many :obligate_subjects
  has_many :voluntary_subjects
  has_one :exam_term
	has_many :indexes
  validates_presence_of :faculty
end
