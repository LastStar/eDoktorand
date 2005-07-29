class Subject < ActiveRecord::Base
  has_many :coridors_subjects
  has_many :plan_subjects
  has_and_belongs_to_many :departments
  validates_presence_of :label
end
