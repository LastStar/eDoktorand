class Leadership < ActiveRecord::Base
  belongs_to :leader
  belongs_to :department
end
