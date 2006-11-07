class Leadership < ActiveRecord::Base
  untranslate_all
  belongs_to :leader
  belongs_to :department
  validates_presence_of :leader
  validates_presence_of :department
end
