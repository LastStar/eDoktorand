class Department < ActiveRecord::Base
  has_many :candidates
  belongs_to :faculty
end
