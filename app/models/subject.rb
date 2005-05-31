class Subject < ActiveRecord::Base
  has_many :coridors_subjects
  validates_presence_of :label
end
