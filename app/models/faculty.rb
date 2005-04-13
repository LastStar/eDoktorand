class Faculty < ActiveRecord::Base
  has_many :coridors
  has_many :departments
  has_many :documents
end
