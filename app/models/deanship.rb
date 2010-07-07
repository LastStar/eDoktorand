class Deanship < ActiveRecord::Base
  
  belongs_to :dean
  belongs_to :faculty
end
