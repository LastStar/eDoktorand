class Coridor < ActiveRecord::Base
  belongs_to :faculty
  has_many :candidates
end
