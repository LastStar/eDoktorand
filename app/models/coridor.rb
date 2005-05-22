class Coridor < ActiveRecord::Base
  belongs_to :faculty
  has_many :candidates
  has_many :coridor_subjects
  has_one :exam_term
  validates_presence_of :faculty
end
