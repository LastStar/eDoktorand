class Faculty < ActiveRecord::Base
  has_many :coridors
  has_many :departments
end
